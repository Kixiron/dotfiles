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
rustup toolchain add beat                        # Add beta toolchain
rustup toolchain add nightly                     # Add nightly toolchain
rustup component add clippy                      # Add clippy
rustup component add clippy --toolchain nightly  # Add clippy nightly
rustup component add rustfmt                     # Add rustfmt
rustup component add rustfmt --toolchain nightly # Add rustfmt nightly
rustup component add rls                         # Add rust language server
rustup component add rust-src                    # Add rust-src
cargo install racer                              # Add racer
cargo install cargo-xbuild                       # Add xbuild
cargo install xargo                              # Add xargo
cargo install cargo-kcov                         # Add kcov
cargo install cargo-bloat                        # Add bloat
cargo install cargo-asm                          # Add asm
cargo install cargo-audit                        # Add audit
cargo install cargo-cache                        # Add cache
cargo install cargo-check                        # Add check
cargo install cargo-clone                        # Add clone
cargo install cargo-count                        # Add count
cargo install cargo-deps                         # Add dependencies
cargo install cargo-expand                       # Add expand
cargo install cargo-license                      # Add license
cargo install cargo-generate                     # Add cargo-generate
cargo install cargo-modules                      # Add modules
cargo install cargo-watch                        # Add watch
cargo install bootimage --version "^0.5.0"       # Add bootimage
cargo --list                                     # List installed extensions
echo "[Done]"

# QEMU
echo "[Installing QEMU]"
echo "y" | apt-get install qemu
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
curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/arc-kde/master/install.sh | sh
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
