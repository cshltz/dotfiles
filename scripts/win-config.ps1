Write-Output "Cleaning Existing Files"

$weztermPath ="$HOME/.wezterm.lua" 
$pwshPath = "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
$lzgitPath = "$HOME/AppData/Local/lazygit/"
$nvimPath = "$HOME/AppData/Local/nvim/"
$ompPath = "$HOME/AppData/Local/Programs/oh-my-posh/themes/gentlenight.omp.json"
if(Test-Path $weztermPath){
    Remove-Item -Path $weztermPath -Force
}
if(Test-Path $pwshPath){
Remove-Item -Path $pwshPath -Force
}
if(Test-Path $lzgitPath){
Remove-Item -Path $lzgitPath -Recurse -Force
}
if(Test-Path $nvimPath){
Remove-Item -Path $nvimPath -Recurse -Force
}
if(Test-Path $ompPath){
Remove-Item -Path $ompPath -Force
}

Write-Output "Copying Wezterm"
Copy-Item -Path "$Env:ENV_SETUP/config/wezterm/*.lua" -Destination "$HOME" -Force
Write-Output "Copying Pwsh"
Copy-Item -Path "$Env:ENV_SETUP/config/pwsh/profile.ps1" -Destination "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1" -Force
Write-Output "Copying lazygit"
Copy-Item -Path "$Env:ENV_SETUP/config/lazygit" -Destination "$HOME/AppData/Local/lazygit/" -Recurse -Force
Write-Output "Copying nvim"
Copy-Item -Path "$Env:ENV_SETUP/config/nvim" -Destination "$HOME/AppData/Local/nvim/" -Recurse -Force
Write-Output "Copying GentleNight"
Copy-Item -Path "$Env:ENV_SETUP/config/pwsh/gentlenight.omp.json" -Destination "$HOME/AppData/Local/Programs/oh-my-posh/themes/" -Force
