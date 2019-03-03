# ~/.config/fish/functions/fish_config.fish

# Fish Config
# Fish
set -g user (whoami)
set -g host (hostname)
set -U EDITOR code

# Colors
set -g color_red FF5555
set -g color_black 212121
set -g color_dark_blue 6272A4
set -g color_pink FF79C6
set -g color_purple BD93F9
set -g color_cyan 8BE9FD
set -g color_orange FFB86C
set -g color_green 50FA7B

# Programming
abbr --add --global py python3
abbr --add --global dotnet dotnet-sdk.dotnet

# Git
abbr --add --global gpull git pull
abbr --add --global gpush git push
abbr --add --global gco git checkout
abbr --add --global gcom git commit
