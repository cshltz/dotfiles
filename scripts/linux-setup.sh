#!/bin/bash

if [[ $1 == "deb" ]]; then
    sudo apt install ripgrep ninja-build gettext cmake build-essential git curl golang-go npm
elif [[ $1 == "arch" ]]; then
    sudo pacman -S ripgrep ninja-build gettext cmake build-essential git curl go
else
    echo "No supported architecture provided."
    exit
fi

#setup dotnet sdks
mkdir -p "$HOME/tmp"
curl -fsSL -o "$HOME/tmp/dotnet-install.sh" https://dot.net/v1/dotnet-install.sh
chmod +x "$HOME/tmp/dotnet-install.sh"
mkdir -p "$HOME/.dotnet"
sudo "$HOME/tmp/dotnet-install.sh" --install-dir "$HOME/.dotnet" -channel 8.0 -version latest
sudo "$HOME/tmp/dotnet-install.sh" --install-dir "$HOME/.dotnet" -channel 10.0 -version latest

#lazygit install
lazygitDir=$HOME/tmp/lazygit
git clone "https://github.com/jesseduffield/lazygit.git" "$lazygitDir"
cd "$lazygitDir" || exit
echo "Installing lazygit"
go install

#update nvim
if [[ $1 == "deb" ]]; then
    git_dir=$HOME/.config/install
    git clone "https://github.com/neovim/neovim" "$git_dir/neovim"
    cd "$git_dir/neovim" || exit
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    echo "Removing repo directory"
    rm -rf "$git_dir"
elif [[ $1 == "arch" ]]; then
    sudo pacman -S neovim
else
    exit
fi

echo "Cleaning up temp folder"
rm -rf "$HOME/tmp"

#turn this into wezterm?
#update tmux
if command -v tmux &>/dev/null; then
    echo "tmux already installed"
else
    if [[ $1 == "deb" ]]; then
        sudo apt install tmux || exit
    elif [[ $1 == "arch" ]]; then
        sudo pacman -S tmux || exit
    fi
fi

#update zsh
echo "Updating ZSH"
if command -v zsh &>/dev/null; then
    echo "zsh already installed. Update it in this code block."
else
    if [[ $1 == "deb" ]]; then
        sudo apt install zsh -y || exit
    elif [[ $1 == "arch" ]]; then
        sudo pacman -S zsh
    fi

    chsh -s /bin/zsh || exit
    source "$HOME/.config/zsh/.zshrc"
fi

#copy config
echo "Copying Config"
cp -a "$ENV_SETUP/config/lazygit" "$HOME/.config/lazygit/" || exit
cp -a "$ENV_SETUP/config/nvim" "$HOME/.config/nvim/" || exit
cp -a "$ENV_SETUP/config/tmux" "$HOME/.config/tmux/" || exit
cp -a "$ENV_SETUP/config/zsh" "$HOME/.config/zsh/" || exit
mv "$HOME/.config/zsh/.zshenv" "$HOME" || exit

#update tmux plugins
echo "Installing tmux catpuccin"
rm -rf "$HOME/.config/tmux/plugins/catppuccin"
git clone -b v2.1.3 "https://github.com/catppuccin/tmux.git" "$HOME/.config/tmux/plugins/catppuccin/"

echo "Installing tmux-sensible"
rm -rf "$HOME/.config/tmux/plugins/tmux-sensible"
git clone "https://github.com/tmux-plugins/tmux-sensible" "$HOME/.config/tmux/plugins/tmux-sensible/"

#update zsh plugins
rm -rf "$HOME/.config/zsh/plugins/"

#zsh-syntax-highlighting
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/plugins/zsh-syntax-highlighting/"

#catppuccin
git clone "https://github.com/catppuccin/zsh-syntax-highlighting.git" "$HOME/.config/plugins/tmp"
cp -v "$HOME/.config/plugins/tmp/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" "$HOME/.config/plugins/catppuccin.zsh"

#remove unneeded git repo
rm -rf "$HOME/.config/plugins/tmp"
