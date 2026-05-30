#!/usr/bin/env bash

if ! nvim --version 2>/dev/null | grep -q "NVIM v0.12.2"; then
    sudo apt-get install -y \
        python3 \
        nodejs \
        npm \
        ninja-build \
        gettext \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        cmake \
        g++ \

        pkg-config \
        unzip \
        git

    git clone --depth 1 --branch v0.12.2 \
        https://github.com/neovim/neovim.git

    cd neovim || exit 1

    make CMAKE_BUILD_TYPE=Release

    sudo make install

    cd .. || exit 1

    rm -rf neovim

    if ! nvim --version 2>/dev/null | grep -q "NVIM v0.12.2"; then
        echo "Neovim installation failed"
        exit 1
    fi

    echo "Neovim 0.12.2 installed successfully"
else
    echo "Neovim 0.12.2 already installed"
fi

USER_HOME=$( getent passwd "$SUDO_USER" | cut -d: -f6)
cd "$USER_HOME/.config/"


sudo -u "$SUDO_USER" bash << EOF 
eval "\$(ssh-agent -s)"
ssh-add "$USER_HOME/.ssh/github_key" >/dev/null 2>&1

if [ ! -d "$USER_HOME/.config/nvim" ]; then
	git clone git@github.com:Hersonrock/nvim_config.git "$USER_HOME/.config/nvim"
else
	echo "~/.config/nvim directory already exists..."
fi
EOF

sudo -u "$SUDO_USER" nvim --headless "+Lazy! sync" +qa
sudo -u "$SUDO_USER" nvim --headless \
  "+MasonInstall lua-language-server clangd pyright bash-language-server" \
  +qa
