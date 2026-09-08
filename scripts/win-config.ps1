Write-Output "Cleaning Existing Files"

$weztermPath ="$HOME/.wezterm.lua"
$pwshPath = "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
$nvimPath = "$HOME/AppData/Local/nvim/"

if(Test-Path $weztermPath)
{
    Remove-Item -Path $weztermPath -Force
}
if(Test-Path $pwshPath)
{
    Remove-Item -Path $pwshPath -Force
}
if(Test-Path $nvimPath)
{
    Remove-Item -Path $nvimPath -Recurse -Force
}

Write-Output "Copying Wezterm"
$weztermConfigPath = "$HOME/.config/wezterm"
if(Test-Path $weztermConfigPath)
{
    Remove-Item -Path $weztermConfigPath -Recurse -Force
}
New-Item -ItemType Directory -Path $weztermConfigPath -Force | Out-Null
Copy-Item -Path "$Env:ENV_SETUP/config/wezterm/*" -Destination $weztermConfigPath -Recurse -Force
Write-Output "Copying Pwsh"
Copy-Item -Path "$Env:ENV_SETUP/config/pwsh/profile.ps1" -Destination $pwshPath -Force
Write-Output "Copying nvim"
Copy-Item -Path "$Env:ENV_SETUP/config/nvim" -Destination $nvimPath -Recurse -Force
