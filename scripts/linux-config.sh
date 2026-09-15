#!/bin/bash

ENV_SETUP="${ENV_SETUP:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# --skip-wezterm: don't manage WezTerm config (WezTerm runs on the host, e.g. WSL)
for arg in "$@"; do
    if [[ $arg == "--skip-wezterm" ]]; then
        skipWezterm=1
    fi
done

if [[ $skipWezterm -ne 1 ]]; then
    read -r -p "Update WezTerm? [y/N] " installWezterm
fi
if [[ $installWezterm =~ ^[Yy]$ ]]; then
    echo "Copying wezterm"
    rm -f "$HOME/.wezterm.lua"
    rm -rf "$XDG_CONFIG_HOME/wezterm"
    mkdir -p "$XDG_CONFIG_HOME/wezterm"
    cp -a "$ENV_SETUP/config/wezterm/." "$XDG_CONFIG_HOME/wezterm/" || exit
fi

echo "Copying nvim"
rm -rf "$XDG_CONFIG_HOME/nvim"
mkdir -p "$HOME/.config/nvim"
cp -a "$ENV_SETUP/config/nvim/." "$HOME/.config/nvim/" || exit
find "$HOME/.config/nvim" -type f -exec sed -i 's/\r$//' {} +

echo "Copying zsh"
rm -rf "$XDG_CONFIG_HOME/zsh"
mkdir -p "$HOME/.config/zsh"
cp -a "$ENV_SETUP/config/zsh/." "$HOME/.config/zsh/" || exit
find "$HOME/.config/zsh" -type f -exec sed -i 's/\r$//' {} +
mv -f "$HOME/.config/zsh/.zshenv" "$HOME" 2>/dev/null || true
sed -i 's/\r$//' "$HOME/.zshenv" 2>/dev/null || true

#update zsh plugins
rm -rf "$HOME/.config/zsh/plugins/"

#zsh-syntax-highlighting (sourced from $ZDOTDIR/plugins/... in .zshrc)
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/"

#remove unneeded git repo
rm -rf "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/.git"
