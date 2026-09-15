# wsl-config.ps1 - refresh configs for the Windows + WSL dev environment.
#
#   1. copies the wezterm config to the host (~/.config/wezterm/), where
#      WezTerm actually runs
#   2. runs scripts/linux-config.sh --skip-wezterm inside the WSL distro to
#      refresh configs for the tools that run inside WSL (nvim, zsh, ...)
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File .\scripts\wsl-config.ps1
#   pwsh -ExecutionPolicy Bypass -File .\scripts\wsl-config.ps1 -Distro Ubuntu-24.04

param(
  [string]$Distro = ''
)

$ErrorActionPreference = 'Stop'

# repo root (same convention as the bash scripts: ENV_SETUP points at the dotfiles dir)
if (-not $Env:ENV_SETUP) {
  $Env:ENV_SETUP = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}
$RepoRoot = $Env:ENV_SETUP

if (-not $Distro) {
  # wsl.exe writes UTF-16 output to a pipe; when PowerShell decodes it as
  # UTF-8, distro names come back with interleaved NUL bytes (or spaces).
  # Strip those before picking the name, or the -d check below fails.
  $Distro = (& wsl --list --quiet) -replace '[\x00\s]', '' |
    Where-Object { $_ } |
    Select-Object -First 1
  if (-not $Distro) { throw 'Could not determine the default WSL distro - pass -Distro.' }
}

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

Write-Output 'wsl-config: refresh configs for the Windows + WSL environment'
Write-Output "repo:   $RepoRoot"
Write-Output "distro: $Distro"

# ------------------------------------------------------------ WezTerm (host)
Write-Header 'WezTerm config (host)'
$weztermConfigPath = Join-Path $HOME '.config\wezterm'
if (Test-Path $weztermConfigPath) {
  Remove-Item -Path $weztermConfigPath -Recurse -Force
}
New-Item -ItemType Directory -Path $weztermConfigPath -Force | Out-Null
Copy-Item -Path (Join-Path $RepoRoot 'config\wezterm\*') `
  -Destination $weztermConfigPath -Recurse -Force
Write-Output "Config copied to $weztermConfigPath"

# --------------------------------------------------- Linux config inside WSL
Write-Header "Running linux-config.sh inside $Distro"
$linuxConfigWsl = ConvertTo-WslPath (Join-Path $RepoRoot 'scripts\linux-config.sh')
wsl -d $Distro -- bash $linuxConfigWsl --skip-wezterm
if ($LASTEXITCODE -ne 0) {
  throw 'linux-config.sh did not complete cleanly - review the output above.'
}

Write-Header 'Done'
Write-Output "1. WezTerm config refreshed on the host in ~/.config/wezterm"
Write-Output "2. WSL configs (nvim, zsh, ...) refreshed in $Distro"