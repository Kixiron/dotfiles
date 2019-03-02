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
    set o (set_color $_dark_blue)
    set m (set_color $_cyan)
    set i (set_color $_purple)
    set t (set_color $_pink)

    echo '                 '$o'___
      ___======____='$m'-'$i'-'$m'-='$o')               '$t'Test'$o'
    /T            \_'$i'--='$m'=='$o')              '$t'Test
    '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')              '$t'Test'$o'
     \      / )J'$m'~~    '$o'\\'$i'-='$o')              '$t'Test'$o'
      \\\\___/  )JJ'$m'~'$i'~~   '$o'\)               '$t'Test'$o'
       \_____/JJJ'$m'~~'$i'~~    '$o'\\              '$t'Test'$o'
       '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\             '$t'Test'$o'
      (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_          '$t'Test'$o'
      '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__      '$t'Test'$o'
       '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\     '$t'Test'$o'
              '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)    '$t'Test'$o'
                          '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)   '$t'Test'$o'
                          (J'$m'JJ'$o'| \UUU)   '$t'Test'$o'
                           (UU)'(set_color normal)
end
funcsave fish_greeting
