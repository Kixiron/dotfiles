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
    set outer (set_color $_dark_blue)
    set middle (set_color $_purple)
    set inner (set_color $_cyan)
    set text (set_color $_pink)
    echo "                 "
    $outer
    echo -n "___               "
    $text
    echo -n "User: $user"
    $outer

    echo "  ___======____="
    $middle
    echo -n "-"
    $inner
    echo -n "-"
    $middle
    echo -n "-="
    $outer
    echo -n ")              "
    $text
    echo -n "Test"
    $outer

    echo "/T            \_"
    $inner
    echo -n "--="
    $middle
    echo -n "=="
    $outer
    echo -n ")             "
    $text
    echo -n "Test"
    $outer

    echo "[ \ "
    $middle
    echo -n "("
    $inner
    echo -n "O"
    $middle
    echo -n ")   "
    $outer
    echo -n "\~    \_"
    $inner
    echo -n "-="
    $middle
    echo -n "="
    $outer
    echo -n ")             "
    $text
    echo -n "Test"
    $outer

    echo " \      / )J"
    $middle
    echo -n "~~    "
    $outer
    echo -n "\\"
    $inner
    echo -n "-="
    $outer
    echo -n ")             "
    $text
    echo -n "Test"
    $outer

    echo "  \\\\___/  )JJ"
    $middle
    echo -n "~"
    $inner
    echo -n "~~   "
    $outer
    echo -n "\)              "
    $text
    echo -n "Test"
    $outer

    echo "   \_____/JJJ"
    $middle
    echo -n "~~"
    $inner
    echo -n "~~    "
    $outer
    echo -n "\\             "
    $text
    echo -n "Test"
    $outer

    echo "   "
    $middle
    echo -n "/ "
    $outer
    echo -n "\  "
    $inner
    echo -n ", \\"
    $outer 
    echo -n "J"
    $middle
    echo -n "~~~"
    $inner
    echo -n "~~     "
    $middle
    echo -n "\\            "
    $text
    echo -n "Test"
    $outer

    echo "  (-"
    $inner
    echo -n "\)"
    $outer
    echo -n "\="
    $middle
    echo -n "|"
    $inner
    echo -n "\\\\\\"
    $middle
    echo -n "~~"
    $inner
    echo -n "~~       "
    $middle
    echo -n "L_"
    $inner
    echo -n "_         "
    $text
    echo -n "Test"
    $outer

    echo "  "
    $middle
    echo -n "("
    $outer
    echo -n "\\"
    $middle
    echo -n "\\)  ("
    $inner
    echo -n "\\"
    $middle
    echo -n "\\\)"
    $outer
    echo -n "_           "
    $inner
    echo -n "\=="
    $middle
    echo -n "__     "
    $text
    echo -n "Test"
    $outer

    echo "   "
    $outer
    echo -n "\V    "
    $middle 
    echo -n "\\\\"
    $outer
    echo -n "\) =="
    $middle
    echo -n "=_____   "
    $inner
    echo -n "\\\\\\\\"
    $middle
    echo -n "\\\\    "
    $text
    echo -n "Test"
    $outer

    echo "          "
    $outer
    echo -n "\V)     \_) "
    $middle
    echo -n "\\\\"
    $inner
    echo -n "\\\\JJ\\"
    $middle
    echo -n "J\)   "
    $text
    echo -n "Test"
    $outer

    echo "                      "
    $outer
    echo -n "/"
    $middle
    echo -n "J"
    $inner
    echo -n "\\"
    $middle
    echo -n "J"
    $outer
    echo -n "T\\"
    $middle
    echo -n "JJJ"
    $outer
    echo -n "J)  "
    $text
    echo -n "Test"
    $outer

    echo "                      (J"
    $middle
    echo -n "JJ"
    $outer
    echo -n "| \UUU)  "
    $text
    echo -n "Test"
    $outer

    echo "                       (UU)        "
    $text
    echo -n "Test"
end
funcsave fish_greeting
