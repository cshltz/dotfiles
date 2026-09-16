#!/bin/bash

ENV_SETUP="${ENV_SETUP:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# --skip-wezterm: don't install WezTerm (WezTerm runs on the host, e.g. WSL)
for arg in "$@"; do
    if [[ $arg == "--skip-wezterm" ]]; then
        skipWezterm=1
    fi
done

if [[ $1 == "deb" ]]; then
    echo "Updating agt-get and installing packages"
    sudo apt-get update
    sudo apt-get install -y ripgrep ninja-build gettext cmake build-essential git curl golang-go fd-find clang unzip zstd file wl-clipboard
elif [[ $1 == "arch" ]]; then
    sudo pacman -S ripgrep ninja gettext cmake base-devel git curl go nodejs npm fd clang wl-clipboard
else
    echo "No supported architecture provided."
    exit
fi

#match the `fd` binary name provided by win-setup
if [[ $1 == "deb" ]] && command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "Downloading and Installing NVM"
#nvm + Node LTS (distro Node 12 is too old for codex and fails global installs with EACCES)
export NVM_DIR="$HOME/.nvm"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

#npm tools (matches win-setup tree-sitter-cli and codex)
echo "Installing tree-sitter-cli"
npm install -g tree-sitter-cli
echo "Installing codex"
npm install -g @openai/codex

echo "Installing copilot cli"
#Copilot CLI (win-setup installs GitHub.Copilot)
curl -fsSL https://gh.io/copilot-install | bash

echo "Installing dot sdks"
#setup dotnet sdks
mkdir -p "$HOME/tmp"
curl -fsSL -o "$HOME/tmp/dotnet-install.sh" https://dot.net/v1/dotnet-install.sh
chmod +x "$HOME/tmp/dotnet-install.sh"
mkdir -p "$HOME/.dotnet"
sudo "$HOME/tmp/dotnet-install.sh" --install-dir "$HOME/.dotnet" -channel 8.0 -version latest
sudo "$HOME/tmp/dotnet-install.sh" --install-dir "$HOME/.dotnet" -channel 10.0 -version latest

echo "Installing lazygit"
#lazygit install (prebuilt binary: source build needs Go >= 1.23, jammy only ships 1.18)
mkdir -p "$HOME/.local/bin"
lazygitVer=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
curl -fsSL -o "$HOME/tmp/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/$lazygitVer/lazygit_${lazygitVer#v}_Linux_x86_64.tar.gz"
tar -xzf "$HOME/tmp/lazygit.tar.gz" -C "$HOME/.local/bin" lazygit

#update nvim
echo "Installing nvim"
if [[ $1 == "deb" ]]; then
    git_dir=$HOME/.config/install
    sudo rm -rf "$git_dir/neovim"
    git clone "https://github.com/neovim/neovim" "$git_dir/neovim"
    cd "$git_dir/neovim" || exit
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    echo "Removing repo directory"
    sudo rm -rf "$git_dir/neovim"
elif [[ $1 == "arch" ]]; then
    sudo pacman -S neovim
else
    exit
fi
cd "$HOME" || exit

echo "Cleaning up temp folder"
rm -rf "$HOME/tmp"

#optional wezterm install (skip if wezterm runs on the host, e.g. in WSL)
if [[ $skipWezterm -ne 1 ]]; then
    read -r -p "Install WezTerm? [y/N] " installWezterm
fi
if [[ $installWezterm =~ ^[Yy]$ ]]; then
    if [[ $1 == "deb" ]]; then
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
        sudo apt update
        sudo apt install wezterm
    elif [[ $1 == "arch" ]]; then
        sudo pacman -S wezterm || exit
    fi
    cp -a "$ENV_SETUP/config/wezterm/wezterm.lua" "$HOME/.wezterm.lua" || exit
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
fi
chsh -s /bin/zsh || echo "chsh failed - set your default shell later with: chsh -s /bin/zsh"

#copy config
echo "Copying Config"
mkdir -p "$HOME/.config/nvim"
cp -a "$ENV_SETUP/config/nvim/." "$HOME/.config/nvim/" || exit
mkdir -p "$HOME/.config/zsh"
cp -a "$ENV_SETUP/config/zsh/." "$HOME/.config/zsh/" || exit
mv -f "$HOME/.config/zsh/.zshenv" "$HOME" 2>/dev/null || true

#update zsh plugins
rm -rf "$HOME/.config/zsh/plugins/"

#zsh-syntax-highlighting (sourced from $ZDOTDIR/plugins/... in .zshrc)
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/"

#remove unneeded git repo
rm -rf "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/.git"
