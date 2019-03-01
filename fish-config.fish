# Fish Config

# Fish
set -g user (whoami)
set -g host (hostname)
set -U EDITOR code

# Colors
set -g _red FF5555
set -g _black 212121
set -g _dark_blue 6272A4
set -g _pink FF79C6
set -g _purple BD93F9
set -g _cyan 8BE9FD
set -g _light_blue 6272A4
set -g _orange FFB86C
set -g _green 50FA7B

# Programming
abbr --add --global py python3
abbr --add --global rustrun (clear; cargo run)

# Git
abbr --add --global gpull git pull
abbr --add --global gpush git push
abbr --add --global gco git checkout
abbr --add --global gcom git commit
