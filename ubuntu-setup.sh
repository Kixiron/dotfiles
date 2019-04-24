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
git clone https://github.com/chubin/cheat.sh.git /usr/cheat.sh
cd /usr/cheat.sh
docker-compose up
cd /
mkdir -p ~/bin/
curl https://cht.sh/:cht.sh > ~/bin/cht.sh
yes | chmod +x ~/bin/cht.sh
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
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/cron/setup.sh | sh
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
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-setup.fish | fish

# Plasma Themes
echo "[Installing Plasma Themes]"
# Themeset:
# https://store.kde.org/p/1300357/
# https://www.opendesktop.org/p/1284743/
# https://store.kde.org/p/1284745/
# https://store.kde.org/p/1296021/
# https://store.kde.org/p/1284748/
# https://store.kde.org/p/1285298/
# https://www.opendesktop.org/p/1287872/
# https://store.kde.org/p/1294604/
# https://store.kde.org/p/1012430/
kde_files=(
    'https://dl.opendesktop.org/api/files/download/id/1555144062/s/c34a70e446e5010313aeb4a6d8c7b467812b37f9892586cb7518908977b5312e4cdc76945b5218a823acbe9450476cd1780031a8cedc7cc10ad7c09fec66ebb7/t/1556144007/u//Flat-Remix-Blue_1.89.tar.xz'
    'https://dl.opendesktop.org/api/files/download/id/1552552531/s/954ce4926781f02bd46a0399e69935d3dd9eeb5ec55280b9f150f4ca4470d6295e2fa6b6f8f7f85e2250e4f0ba048dea4f658a09bc3cffcfa0fdbb4e5a57f41e/t/1556144579/u//forceblur.kwinscript'
    'https://dl.opendesktop.org/api/files/download/id/1549017406/s/21e3f1b5f3e4409a46177a94ef248b17251d5e38d43b44dd30ae0ded5f27a741c8ec844deaa0ee5d3f15acc433c081ab98dbd3e4b0aaab0e168412b1c82df352/t/1556144707/u//Harmony.tar.gz'
    'https://dl.opendesktop.org/api/files/download/id/1547556832/s/6a63d188f7e7e7feb90e35806b2bf9d2a2b744ceed16bc18419118be8e088ba8943518476bd6bbb8639f19057d74883bb814569a83bd293fb343d9fdc909ad42/t/1556144733/u//Harmony.colorscheme'
    'https://dl.opendesktop.org/api/files/download/id/1555163845/s/1aa223cd49f46d94e94dd9ee0c59af340dd21aa5988e0359e4b7ed4747fc629f74cfaca205e25df9dddc393908601f8cb349e70c4230ccffd47964067805279d/t/1556144756/u//harmony.tar.gz'
    'https://dl.opendesktop.org/api/files/download/id/1553244754/s/6f945eda1f9ec91d6ed3cf0dee0b4f920ec64667b164e44c940185c7e9e39eb32d5404444474553611dec6652393d64a82753be1ef57e7d030f3c3d13a8cbf5d/t/1556144773/u//Harmony.tar.gz'
    'https://dl.opendesktop.org/api/files/download/id/1547241436/s/42abf2c88c7f8428846639d90765fd559c17f4ad62834e2c4e9314d78c5b16dc605f32450b89dd30945b496005faee8b31645053814f2611c39cb8d49e72a3b8/t/1556144795/u//HarmonyDark.colors'
    'https://dl.opendesktop.org/api/files/download/id/1552685752/s/51367f37e0fcd0e4d1a2d010372af5bd62665ec191a7ca17967d2c7c226b5c61703f16ac74a820ecbebb169c13f8849e7ef08623c46a8d58fbe80838fafcd74b/t/1556144818/u//Harmony.tar.gz'
    'https://dl.opendesktop.org/api/files/download/id/1555583188/s/ea8f1de09e066db9a4fb79b01a246aa35aedd3864f0c92363a9fc49b8f0dba870ab7bd0da0c26ed0f3fd84439273660b0c05438ae7c95397ab11b60dccfb0578/t/1556144839/u//harmony-v.3.tar.gz'
)
for kde_file in "${kde_files[@]}"; do
    current_kde=curl $kde_file
    tar -xf $current_kde -C /tmp
done
echo "[Done]"

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
