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

# Git
abbr --add --global gpull git pull
abbr --add --global gpush git push
abbr --add --global gco git checkout
abbr --add --global gcom git commit

# Fish Greeting
function fish_greeting
    set mouth "["
    set eye "O"
    set o (set_color $color_dark_blue)
    set m (set_color $color_cyan)
    set i (set_color $color_purple)
    set t (set_color $color_pink)
    set shell_prefix "/usr/bin/"
    set x_dimension (xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
    set y_dimension (xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

    echo '                 '$o'___
      ___======____='$m'-'$i'-'$m'-='$o')               '$t'User: $user'$o'
    /T            \_'$i'--='$m'=='$o')              '$t'Host: $host'$o'
    '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')              '$t'OS: (uname) (uname -m)'$o'
     \      / )J'$m'~~    '$o'\\'$i'-='$o')              '$t'Uptime: (uptime | awk -F'( |,|:)+' '{print $6,$7",",$8,"hours,",$9,"minutes."}')'$o'
      \\\\___/  )JJ'$m'~'$i'~~   '$o'\)               '$t'Shell: ($SHELL | sed -e "s/^$shell_prefix//")'$o'
       \_____/JJJ'$m'~~'$i'~~    '$o'\\              '$t'Resolution: ' $x_dimension 'x' $y_dimension '$o'
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
