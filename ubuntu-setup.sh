#!/bin/bash

# Update
echo "[Updating and Upgrading]"
yes | apt update
yes | apt upgrade
yes | apt dist-upgrade
echo "[Done]"

# Setup
echo "[Setting up]"
yes | apt install software-properties-common apt-transport-https wget
yes | apt install apt-transport-https ca-certificates curl software-properties-common
mkdir /usr/code
echo "[Done]"

# Make Tools
echo "[Installing Make Tools]"
yes | apt install make
yes | apt install automake
yes | apt install pkg-config
yes | apt install autoconf
echo "[Done]"

# Snap
echo "[Installing Snap]"
yes | apt install snapd
echo "[Done]"
echo "[Installing Snap Packages]"
snap install code --classic
snap install discord
snap install docker
snap install spotify
snap install krita
snap install kubectl --classic
snap install redis-desktop-manager
snap install obs-studio
snap install electronplayer
snap install lepton
echo "[Done]"

# Docker Compose
echo "[Installing Docker Compose]"
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
yes | chmod +x /usr/local/bin/docker-compose
echo "[Done]"

# Cheat.sh
echo "[Installing Cheat.sh]"
git clone https://github.com/chubin/cheat.sh.git /usr/local/cheat.sh
cd /usr/cheat.sh
docker-compose up
cd /
mkdir -p ~/bin/
curl https://cht.sh/:cht.sh > ~/bin/cht.sh
yes | chmod +x ~/bin/cht.sh
echo "[Done]"

# Docker
echo "[Starting Docker Containers]"
cd /usr/local/kugelblitz
git clone https://github.com/Kixiron/kugelblitz.git ./
docker build . --tag kugelblitz --rm=false
docker run -d --name Kugelblitz --rm=false kugelblitz
cd /
echo "[Done]"

# Kubuntu
echo "[Installing Kubuntu]"
yes | add-apt-repository ppa:kubuntu-ppa/backports
yes | apt install kubuntu-desktop
echo "[Done]"

# Git
echo "[Installing Git]"
yes | apt install git-all
echo "[Done]"

# Audacity
echo "[Installing Audacity]"
yes | add-apt-repository ppa:ubuntuhandbook1/audacity
yes | get install audacity
echo "[Done]"

# Rust/Cargo
echo "[Installing Rust]"
curl -sf -L https://static.rust-lang.org/rustup.sh | sh -s -- -y # Run with defaults
PATH=$PATH:~/.cargo/env
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
cargo install cargo-web                          # Add client-side web
cargo install cargo-multi                        # Add multi command
cargo --list                                     # List installed extensions
echo "[Done]"

echo "[Setting up cron]"
sh $(curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/cron/setup.sh)
echo "[Done]"

# GCC
echo "[Installing GCC]"
yes | apt install GCC
echo "[Done]"

# Fish
echo "[Installing Fish]"
yes | apt install fish
echo /usr/local/bin/fish | tee -a /etc/shells
yes | chsh -s /usr/local/bin/fish
PATH=$PATH:~/usr/local/bin/fish
echo "[Done]"

# Configure fish
fish $(curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-setup.fish)

# Finish
echo "[Finishing]"
snap refresh
yes | apt update
yes | apt upgrade
yes | apt dist-upgrade
echo "[Done]"

# Clean cache
echo "[Installing Cleaning]"
yes | apt clean
yes | apt autoremove
echo "[Done]"

echo "[Finished Setting Up]"
echo ""
echo "Make sure to restart for all changes to take effect"
