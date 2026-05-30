#!/usr/bin/env bash

dpkg -s neovim >/dev/null 2>&1
if [ $? -eq 1 ]; then
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
	sudo apt install git -y
	git clone --depth 1 --branch v0.12.2 https://github.com/neovim/neovim.git
	cd neovim
	git checkout v0.12.2
	make CMAKE_BUILD_TYPE=Release
	sudo make install
	cd ..
	rm -rf neovim

	if nvim --version | grep -q "NVIM v0.12.2"; then
	    echo "Neovim 12.2 installed successfully"
	fi
else
	echo "neovim already installed..."
fi

USER_HOME=$( getent passwd "$SUDO_USER" | cut -d: -f6)
cd "$USER_HOME/.config/"


sudo -u "$SUDO_USER" bash << EOF 
eval "\$(ssh-agent -s)"
ssh-add $USER_HOME/.ssh/github_key >/dev/null 2>&1

if [ ! -d "$USER_HOME/.config/nvim" ]; then
	git clone git@github.com:Hersonrock/nvim_config.git "$USER_HOME/.config/nvim"
else
	echo "~/.config/nvim directory already exists..."
fi
EOF
