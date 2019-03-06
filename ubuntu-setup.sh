#!/bin/bash

# Update
echo "[Updating and Upgrading]"
apt update
apt upgrade
apt dist-upgrade
echo "[Done]"

# Setup
echo "[Setting up]"
echo "y" | apt install software-properties-common apt-transport-https wget
echo "y" | apt install apt-transport-https ca-certificates curl software-properties-common
echo "[Done]"

# Make Tools
echo "[Installing Make Tools]"
echo "y" | apt install make
echo "y" | apt install automake
echo "y" | apt install pkg-config
echo "y" | apt install autoconf
echo "[Done]"

# Snap
echo "[Installing Snap]"
echo "y" | apt install snapd
echo "[Done]"

# Kubuntu
echo "[Installing Kubuntu]"
add-apt-repository ppa:kubuntu-ppa/backports
echo "y" | apt install kubuntu-desktop
echo "[Done]"

# Visual Studio Code
echo "[Installing Visual Studio Code]"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo "y" | apt install apt-transport-https
echo "y" | apt install code
update-alternatives --set editor /usr/bin/code
echo "[Done]"

# Git
echo "[Installing Git]"
echo "y" | apt install git-all
echo "[Done]"

# Discord
echo "[Installing Discord]"
snap install discord
echo "[Done]"

# Audacity
echo "[Installing Audacity]"
add-apt-repository ppa:ubuntuhandbook1/audacity
get install audacity
echo "[Done]"

# Docker
echo "[Installing Docker]"
snap install docker
echo "[Done]"

# Spotify
echo "[Installing Spotify]"
snap install spotify
echo "[Done]"

# Rust/Cargo
echo "[Installing Rust]"
curl -sf -L https://static.rust-lang.org/rustup.sh | sh -s -- -y # Run with defaults
source $HOME/.cargo/env # Path
rustup update
rustup self update
cargo update
rustup toolchain add nightly # Add nightly toolchain
rustup component add clippy # Add clippy
rustup component add rustfmt # Add rustfmt
cargo +nightly install racer # Add racer
echo "[Done]"

# GCC
echo "[Installing GCC]"
apt install GCC
echo "[Done]"

# .NET
echo "[Installing .NET]"
snap install dotnet-sdk --classic
echo "[Done]"

# Fish
echo "[Installing Fish]"
echo "y" | apt install fish
echo /usr/local/bin/fish | tee -a /etc/shells
chsh -s /usr/local/bin/fish
echo "[Done]"

# NPM
echo "[Installing NPM]"
echo "y" | apt install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_11.x | -E bash -
echo "y" | apt install nodejs
echo "[Done]"

# Typescript
echo "[Installing Typescript]"
npm install -g typescript
echo "[Done]"

# Configure fish
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-setup.fish | fish

# Plasma Themes
echo "[Installing ARC]"
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/arc-kde/master/install.sh | sh
echo "[Remember to install Chill SDDM https://github.com/MarianArlt/kde-plasma-chili]"
echo "[Done]"

# Finish
echo "[Finishing]"
snap refresh
apt update
apt upgrade
apt dist-upgrade
echo "[Done]"

# Clean cache
echo "[Installing Cleaning]"
apt clean
echo "y" | apt autoremove
echo "[Done]"

echo "[Finished Setting Up]"
echo ""
echo "Make sure to restart for all changes to take effect"
