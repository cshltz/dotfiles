#!/bin/bash

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
