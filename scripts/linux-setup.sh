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
    sudo apt-get install -y ripgrep ninja-build gettext cmake build-essential git curl golang-go fd-find clang unzip zstd file wl-clipboard lazygit nodejs npm
elif [[ $1 == "arch" ]]; then
    sudo pacman -S ripgrep ninja gettext cmake base-devel git curl go nodejs npm fd clang wl-clipboard lazygit
else
    echo "No supported architecture provided."
    exit
fi

#match the `fd` binary name provided by win-setup
if [[ $1 == "deb" ]] && command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "Installing npm tools (matches win-setup tree-sitter-cli and codex)"
sudo npm install -g tree-sitter-cli
echo "Installing codex"
sudo npm install -g @openai/codex

echo "Installing copilot cli (npm)"
sudo npm install -g @github/copilot

echo "Installing dotnet SDKs (apt)"
#dotnet SDK via apt - avoids the blocked dot.net / builds.dotnet.microsoft.com endpoints.
if [[ $1 == "deb" ]]; then
    #.NET 8 is EOL and not in the 26.04 main repos - add the dotnet/backports PPA on demand
    if ! sudo apt-cache policy dotnet-sdk-8.0 | grep -q 'Candidate:'; then
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:dotnet/backports
        sudo apt-get update
    fi
    if sudo apt-cache policy dotnet-sdk-8.0 | grep -q 'Candidate:'; then
        sudo apt-get install -y dotnet-sdk-8.0 dotnet-sdk-10.0
    else
        echo "ERROR: dotnet-sdk-8.0 is not in the apt index after adding the dotnet/backports PPA." >&2
        echo "If you saw an SSL cert error above, this network's TLS-inspection root is not trusted in WSL." >&2
    fi
fi

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
#strip CRLF - a Windows checkout (core.autocrlf) copies \r\n and breaks sh/zsh
find "$HOME/.config/nvim" -type f -exec sed -i 's/\r$//' {} +
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
