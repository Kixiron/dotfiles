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
    set mouth "["
    set eye "O"
    set o (set_color $_purple)
    set m (set_color $_cyan)
    set i (set_color $_dark_blue)

    echo '                 '$o'___
      ___======____='$m'-'$i'-'$m'-='$o')
    /T            \_'$i'--='$m'=='$o')
    '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')
     \      / )J'$m'~~    '$o'\\'$i'-='$o')
      \\\\___/  )JJ'$m'~'$i'~~   '$o'\)
       \_____/JJJ'$m'~~'$i'~~    '$o'\\
       '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\
      (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_
      '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__
       '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\
              '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)
                          '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)
                          (J'$m'JJ'$o'| \UUU)
    (UU)'(set_color normal)
end
funcsave fish_greeting
