# wsl-setup.ps1 - single entry point for a Windows + WSL dev environment.
#
#   1. installs QOL tools on the host (winget): WezTerm, lazygit, nvim, plus their
#      configs and the PowerShell profile
#   2. ensures WSL2 is enabled
#   3. installs a Debian-family distro
#   4. creates the Linux user (same name as the Windows user) and sets /etc/wsl.conf
#   5. runs scripts/linux-setup.sh deb inside that distro
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File .\scripts\wsl-setup.ps1
#   pwsh -ExecutionPolicy Bypass -File .\scripts\wsl-setup.ps1 -Distro Ubuntu-26.04
#
# Notes:
#   * Requires Windows 10 2004+/Windows 11. WSL install may require a reboot.
#   * Run from an elevated prompt if WSL/winget need admin rights.
#   * Targets Ubuntu 26.04+; older LTS distros are NOT recommended (toolchain versions
#     in linux-setup are pinned to what resolute ships).

param(
  [string]$Distro = 'Ubuntu-26.04',
  [string]$UserName = '',
  [switch]$SkipHostTools,
  [switch]$SkipDistro,
  [switch]$SkipLinuxSetup
)

$ErrorActionPreference = 'Stop'

# repo root (same convention as the bash scripts: ENV_SETUP points at the dotfiles dir)
if (-not $Env:ENV_SETUP) {
  $Env:ENV_SETUP = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}
$RepoRoot = $Env:ENV_SETUP

if (-not $UserName) { $UserName = $env:USERNAME }
$WslUser = $UserName.ToLowerInvariant()

function ConvertTo-WslPath {
  param([string]$WinPath)
  if ($WinPath -match '^([a-zA-Z]):\\(.*)$') {
    return "/mnt/$($matches[1].ToLower())/$($matches[2] -replace '\\', '/')"
  }
  throw "Cannot map path to a WSL path (expected a drive-letter path): $WinPath"
}

function Write-Header {
  param([string]$Message)
  Write-Output ''
  Write-Output "==> $Message"
}

# ------------------------------------------------------------ Host QOL tools
function Install-HostTools {
  if ($SkipHostTools) { return }

  Write-Header 'WezTerm (host)'
  if (Get-Command wezterm.exe -ErrorAction SilentlyContinue) {
    Write-Output 'WezTerm already installed.'
  } else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
      throw 'winget not found - install the App Installer from the Store first.'
    }
    Write-Output 'Installing WezTerm'
    winget install --id wez.wezterm --source winget `
      --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw 'winget failed to install WezTerm.' }
  }

  Write-Header 'WezTerm config (host)'
  $weztermConfigPath = Join-Path $HOME '.config\wezterm'
  if (Test-Path $weztermConfigPath) {
    Remove-Item -Path $weztermConfigPath -Recurse -Force
  }
  New-Item -ItemType Directory -Path $weztermConfigPath -Force | Out-Null
  Copy-Item -Path (Join-Path $RepoRoot 'config\wezterm\*') `
    -Destination $weztermConfigPath -Recurse -Force
  Write-Output "Config copied to $weztermConfigPath"

  Write-Header 'lazygit (host)'
  if (Get-Command lazygit.exe -ErrorAction SilentlyContinue) {
    Write-Output 'lazygit already installed.'
  } else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
      throw 'winget not found - install the App Installer from the Store first.'
    }
    Write-Output 'Installing lazygit'
    winget install -e --id JesseDuffield.lazygit --source winget `
      --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw 'winget failed to install lazygit.' }
  }

  Write-Header 'nvim (host)'
  if (Get-Command nvim.exe -ErrorAction SilentlyContinue) {
    Write-Output 'nvim already installed.'
  } else {
    Write-Output 'Installing Neovim'
    winget install --id Neovim.Neovim --source winget `
      --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw 'winget failed to install Neovim.' }
  }

  Write-Header 'PowerShell profile modules (host)'
  foreach ($m in @('Terminal-Icons', 'Pscx', 'PowerColorLS', 'Posh-Git')) {
    if (Get-Module -ListAvailable -Name $m) {
      Write-Output "Module $m already installed."
    } else {
      Write-Output "Installing module $m"
      Install-Module -Name $m -Repository PSGallery -Scope CurrentUser -Force
    }
  }
  Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force

  Write-Header 'PowerShell profile (host)'
  $pwshProfile = Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
  $pwshProfileDir = Split-Path $pwshProfile
  if (-not (Test-Path $pwshProfileDir)) {
    New-Item -ItemType Directory -Path $pwshProfileDir -Force | Out-Null
  }
  Copy-Item -Path (Join-Path $RepoRoot 'config\pwsh\profile.ps1') `
    -Destination $pwshProfile -Force
  Write-Output "Profile copied to $pwshProfile"

  Write-Header 'nvim config (host)'
  $nvimConfigPath = Join-Path $HOME 'AppData\Local\nvim'
  if (Test-Path $nvimConfigPath) {
    Remove-Item -Path $nvimConfigPath -Recurse -Force
  }
  Copy-Item -Path (Join-Path $RepoRoot 'config\nvim') `
    -Destination $nvimConfigPath -Recurse -Force
  Write-Output "Config copied to $nvimConfigPath"
}

# ------------------------------------------------------------------------ WSL 2
function Ensure-Wsl {
  Write-Header 'WSL'
  $wslFound = [bool](Get-Command wsl.exe -ErrorAction SilentlyContinue)
  if (-not $wslFound) {
    Write-Output 'WSL is not installed. Running wsl --install.'
    wsl --install --no-distribution
    if ($LASTEXITCODE -ne 0) {
      throw 'wsl --install failed. Re-run from an elevated prompt, then restart Windows.'
    }
  }
  try {
    Write-Output 'Setting WSL2 as default version.'
    wsl --set-default-version 2 *>$null
  } catch {
    # older wsl.exe does not support --set-default-version; WSL2 is the default then
  }
}

# ----------------------------------------------------------------------- Distro
function Get-InstalledDistros {
  $raw = & wsl --list --quiet 2>$null
  # wsl.exe writes UTF-16 output to a pipe; strip any NULs/spaces that
  # PowerShell decodes so names match cleanly.
  return (($raw -replace '[\x00\s]', '') -join "`n")
}

function Ensure-Distro {
  if ($SkipDistro) { return }
  Write-Header "Distro: $Distro"
  $installed = Get-InstalledDistros
  if ($installed -match [regex]::Escape($Distro)) {
    Write-Output "$Distro already installed."
  } else {
    Write-Output "Installing $Distro"
    wsl --install -d $Distro
    if ($LASTEXITCODE -ne 0) {
      throw "wsl --install -d $Distro failed. If a reboot was requested, reboot and re-run."
    }
  }

  Write-Output "Booting $Distro once to initialize it (first boot can take a minute)..."
  wsl -d $Distro -u root -- true
  if ($LASTEXITCODE -ne 0) {
    throw "Could not boot $Distro. WSL may need a Windows reboot first."
  }
  try {
    wsl --set-default $Distro *>$null
  } catch { }
}

# --------------------------------------------------------- Linux user bootstrap
function Bootstrap-LinuxUser {
  Write-Header 'Creating Linux user'
  Write-Output "(if the distro's own first-run already created '$WslUser', reuse that same password)"
  $pw = Read-Host "Password for Linux user '$WslUser' (used for sudo and chsh)" -AsSecureString
  if ($null -eq $pw -or $pw.Length -eq 0) { throw 'A password is required.' }
  $plain = [System.Net.NetworkCredential]::new('', $pw).Password

  $bootstrap = @'
#!/bin/bash
set -eu
USER="${1:?usage: bootstrap <user>}"
read -r PW
if [ -z "$PW" ]; then
  echo "no password received on stdin" >&2
  exit 1
fi
if ! command -v sudo >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq sudo
fi
if ! id "$USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USER"
fi
usermod -aG sudo "$USER"
echo "$USER:$PW" | chpasswd
echo "$USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER"
chmod 0440 "/etc/sudoers.d/$USER"
printf '[user]\ndefault=%s\n' "$USER" > /etc/wsl.conf
'@
  $bootstrapPath = Join-Path $env:TEMP 'wsl-bootstrap.sh'
  [System.IO.File]::WriteAllText(
    $bootstrapPath,
    ($bootstrap -replace "`r`n", "`n")
  )

  try {
    $bootstrapWsl = ConvertTo-WslPath $bootstrapPath
    $plain | wsl -d $Distro -u root -- bash $bootstrapWsl $WslUser
    if ($LASTEXITCODE -ne 0) { throw "Bootstrap failed for user '$WslUser'." }
  } finally {
    Remove-Item $bootstrapPath -Force -ErrorAction SilentlyContinue
  }
  Write-Output "Linux user '$WslUser' ready on $Distro (default user via /etc/wsl.conf)."
}

# ------------------------------------------------------- Linux setup inside WSL
function Invoke-LinuxSetup {
  if ($SkipLinuxSetup) { return }
  Write-Header "Running linux-setup.sh inside $Distro as $WslUser"
  $linuxSetupWsl = ConvertTo-WslPath (Join-Path $RepoRoot 'scripts\linux-setup.sh')
  wsl -d $Distro -u $WslUser -- bash $linuxSetupWsl deb --skip-wezterm
  if ($LASTEXITCODE -ne 0) {
    Write-Warning 'linux-setup.sh did not complete cleanly - review the output above.'
  }
  wsl -d $Distro -u root -- chsh -s /bin/zsh $WslUser 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Could not set /bin/zsh as default shell for '$WslUser' - run manually: wsl -d $Distro -u root -- chsh -s /bin/zsh $WslUser"
  }
}

# ------------------------------------------------------------------------ main
Write-Output 'wsl-setup: Windows + WSL environment bootstrap'
Write-Output "repo:       $RepoRoot"
Write-Output "distro:     $Distro"
Write-Output "linux user: $WslUser"

Install-HostTools
Ensure-Wsl
Ensure-Distro
Bootstrap-LinuxUser
Invoke-LinuxSetup

Write-Header 'Done'
Write-Output "1. Host QOL: WezTerm + lazygit + nvim installed, with nvim config in ~/AppData/Local/nvim, wezterm config in ~/.config/wezterm, and the pwsh profile set up in ~/Documents/PowerShell"
Write-Output "2. WSL2 + $Distro ready, default Linux user: $WslUser"
Write-Output "3. linux-setup.sh ran inside WSL (sudo is passwordless for $WslUser)"
Write-Output "Start the environment:  wsl    (or launch WezTerm and run wsl)"
Write-Output 'If WSL was just installed, reboot Windows once before launching a distro.'
Write-Output '::GIT::'
Write-Output 'To setup git credential management through Windows and WSL, run:'
Write-Output 'git config --global credential.helper "/mnt/c/Progra~1/Git/mingw64/bin/git-credential-manager.exe"'
Write-Output 'then, add the following to /etc/wsl.conf'
Write-Output '[interop]'
Write-Output 'enabled=true'
Write-Output 'appendWindowsPath=true'
