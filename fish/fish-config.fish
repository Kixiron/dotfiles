# ~/.config/fish/functions/fish_config.fish

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

# Git
abbr --add --global gpull git pull
abbr --add --global gpush git push
abbr --add --global gco git checkout
abbr --add --global gcom git commit

# Fish Greeting
function fish_greeting
    echo "                 "
    set_color $_dark_blue
    echo -n "___               "
    set_color $_pink
    echo -n "User: $user"
    set_color $_dark_blue

    echo "  ___======____="
    set_color $_purple
    echo -n "-"
    set_color $_cyan
    echo -n "-"
    set_color $_purple
    echo -n "-="
    set_color $_dark_blue
    echo -n ")              "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "/T            \_"
    set_color $_cyan
    echo -n "--="
    set_color $_purple
    echo -n "=="
    set_color $_dark_blue
    echo -n ")             "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "[ \ "
    set_color $_purple
    echo -n "("
    set_color $_cyan
    echo -n "O"
    set_color $_purple
    echo -n ")   "
    set_color $_dark_blue
    echo -n "\~    \_"
    set_color $_cyan
    echo -n "-="
    set_color $_purple
    echo -n "="
    set_color $_dark_blue
    echo -n ")             "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo " \      / )J"
    set_color $_purple
    echo -n "~~    "
    set_color $_dark_blue
    echo -n "\\"
    set_color $_cyan
    echo -n "-="
    set_color $_dark_blue
    echo -n ")             "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "  \\\\___/  )JJ"
    set_color $_purple
    echo -n "~"
    set_color $_cyan
    echo -n "~~   "
    set_color $_dark_blue
    echo -n "\)              "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "   \_____/JJJ"
    set_color $_purple
    echo -n "~~"
    set_color $_cyan
    echo -n "~~    "
    set_color $_dark_blue
    echo -n "\\             "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "   "
    set_color $_purple
    echo -n "/ "
    set_color $_dark_blue
    echo -n "\  "
    set_color $_cyan
    echo -n ", \\"
    set_color $_dark_blue 
    echo -n "J"
    set_color $_purple
    echo -n "~~~"
    set_color $_cyan
    echo -n "~~     "
    set_color $_purple
    echo -n "\\            "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "  (-"
    set_color $_cyan
    echo -n "\)"
    set_color $_dark_blue
    echo -n "\="
    set_color $_purple
    echo -n "|"
    set_color $_cyan
    echo -n "\\\\\\"
    set_color $_purple
    echo -n "~~"
    set_color $_cyan
    echo -n "~~       "
    set_color $_purple
    echo -n "L_"
    set_color $_cyan
    echo -n "_         "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "  "
    set_color $_purple
    echo -n "("
    set_color $_dark_blue
    echo -n "\\"
    set_color $_purple
    echo -n "\\)  ("
    set_color $_cyan
    echo -n "\\"
    set_color $_purple
    echo -n "\\\)"
    set_color $_dark_blue
    echo -n "_           "
    set_color $_cyan
    echo -n "\=="
    set_color $_purple
    echo -n "__     "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "   "
    set_color $_dark_blue
    echo -n "\V    "
    set_color $_purple 
    echo -n "\\\\"
    set_color $_dark_blue
    echo -n "\) =="
    set_color $_purple
    echo -n "=_____   "
    set_color $_cyan
    echo -n "\\\\\\\\"
    set_color $_purple
    echo -n "\\\\    "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "          "
    set_color $_dark_blue
    echo -n "\V)     \_) "
    set_color $_purple
    echo -n "\\\\"
    set_color $_cyan
    echo -n "\\\\JJ\\"
    set_color $_purple
    echo -n "J\)   "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "                      "
    set_color $_dark_blue
    echo -n "/"
    set_color $_purple
    echo -n "J"
    set_color $_cyan
    echo -n "\\"
    set_color $_purple
    echo -n "J"
    set_color $_dark_blue
    echo -n "T\\"
    set_color $_purple
    echo -n "JJJ"
    set_color $_dark_blue
    echo -n "J)  "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "                      (J"
    set_color $_purple
    echo -n "JJ"
    set_color $_dark_blue
    echo -n "| \UUU)  "
    set_color $_pink
    echo -n "Test"
    set_color $_dark_blue

    echo "                       (UU)        "
    set_color $_pink
    echo -n "Test"
end
funcsave fish_greeting
