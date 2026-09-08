#!/bin/bash

echo "Copying wezterm"
rm -f "$HOME/.wezterm.lua"
rm -rf "$XDG_CONFIG_HOME/wezterm"
mkdir -p "$XDG_CONFIG_HOME/wezterm"
cp -a "$ENV_SETUP/config/wezterm/." "$XDG_CONFIG_HOME/wezterm/" || exit

echo "Copying nvim"
rm -rf "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_CONFIG_HOME/nvim"
cp -a "$ENV_SETUP/config/nvim" "$HOME/.config/nvim/" || exit

echo "Copying zsh"
rm -rf "$XDG_CONFIG_HOME/zsh"
mkdir -p "$XDG_CONFIG_HOME/zsh"
cp -a "$ENV_SETUP/config/zsh" "$HOME/.config/zsh/" || exit
mv "$HOME/.config/zsh/.zshenv" "$HOME" || exit

#update zsh plugins
rm -rf "$HOME/.config/zsh/plugins/"

#zsh-syntax-highlighting
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/plugins/zsh-syntax-highlighting/"

#remove unneeded git repo
rm -rf "$HOME/.config/plugins/tmp"
