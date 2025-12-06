Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name Pscx -AllowPrerelease
Install-Module -Name PowerColorLS
Install-Module -Name Pansies -AllowClobber
Install-Module -Name Posh-Git
Install-Module -Name PSReadLine -AllowPrerelease -Force

Write-Output "Install clang"
winget install -i --id LLVM.LLVM --source winget
Write-Output "Install WezTerm"
winget install --id wez.wezterm --source winget
Write-Output "Install GIT"
winget install --id Git.Git --source winget
Write-Output "Install curl"
winget install --id curl.curl --source winget
Write-Output "Install ripgrep"
winget install --id BurntSushi.ripgrep.MSVC --source winget
Write-Output "Install go"
winget install --id golang.go --source winget
Write-Output "Install node"
winget install --id OpenJS.NodeJS --source winget
Write-Output "Install neovim"
winget install --id Neovim.Neovim --source winget
Write-Output "Install pwsh"
winget install --id Microsoft.Powershell --source winget
Write-Output "Install Oh My Posh"
winget install --id JanDeDobbeleer.OhMyPosh --source winget
Write-Output "Install lazygit"
winget install -e --id JesseDuffield.lazygit --source winget
Write-Output "Install dotnet 8"
winget install --id Microsoft.DotNet.SDK.8 --source winget
Write-Output "Install dotnet 10"
winget install --id Microsoft.DotNet.SDK.10 --source winget

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
