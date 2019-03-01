#!/bin/bash

# Update
echo "[Updating and Upgrading]"
apt-get update
apt-get upgrade
apt-get dist-upgrade
echo "[Done]"

# Setup
echo "[Setting up]"
apt install software-properties-common apt-transport-https wget
apt install apt-transport-https ca-certificates curl software-properties-common
echo "[Done]"

# Make Tools
echo "[Installing Make Tools]"
apt install make
apt install automake
apt install pkg-config
apt install autoconf
echo "[Done]"

# Snap
echo "[Installing Snap]"
apt install snapd
echo "[Done]"

# Visual Studio Code
echo "[Installing Visual Studio Code]"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt-get install apt-transport-https
apt-get update
apt-get install code
echo "[Done]"

# Git
echo "[Installing Git]"
apt install git-all
echo "[Done]"

# Discord
echo "[Installing Discord]"
snap install discord
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
curl -sf -L https://static.rust-lang.org/rustup.sh | sh -s -y
echo "[Done]"

# Fish
echo "[Installing Fish]"
apt install fish
echo "[Done]"

# NPM
echo "[Installing NPM]"
apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_11.x | -E bash -
apt-get install nodejs
echo "[Done]"

# Typescript
echo "[Installing Typescript]"
npm install -g typescript
echo "[Done]"

# Behavior
echo "[Configuring Behavior]"
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.desktop.interface show-battery-percentage true
echo "[Done]"

# Configure fish
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish-setup.fish | fish

# Finish
echo "[Finishing]"
snap refresh
apt-get update
apt-get upgrade
apt-get dist-upgrade
echo "[Done]"

# Clean cache
echo "[Installing Cleaning]"
apt clean
apt autoremove
echo "[Done]"

echo "[Finished Setting Up]"
echo ""
echo "Make sure to restart for all changes to take effect"
