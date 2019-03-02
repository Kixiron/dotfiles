# Fish Greeting

function fish_greeting
    set mouth "["
    set eye "O"
    set o (set_color $color_dark_blue)
    set m (set_color $color_cyan)
    set i (set_color $color_purple)
    set t (set_color $color_pink)

    set os (head -n1 /etc/issue)" "(uname -m)
    set resolution (xrandr --current | grep '*' | uniq | awk '{ print $1 }' | cut -d 'x' -f1)"x"(xrandr --current | grep '*' | uniq | awk '{ print $1 }' | cut -d 'x' -f2)
    set uptime (uptime | awk -F'( |,|:)+' '{ print $6, $7",", $8, "hours," }')
    set cpu (lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{ $1=$1 } 1')
    set threads (nproc)
    set total_mem (free | awk '/^Mem:/ { print int($2 / 1000000) }')

    echo '                 '$o'___
      ___======____='$m'-'$i'-'$m'-='$o')               '$t'User: '$user $o'
    /T            \_'$i'--='$m'=='$o')              '$t'Host: '$host $o'
    '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')              '$t'OS: '$os $o'
     \      / )J'$m'~~    '$o'\\'$i'-='$o')              '$t'Uptime: '$uptime $o'
      \\\\___/  )JJ'$m'~'$i'~~   '$o'\)               '$t'Memory: '$total_mem $o'
       \_____/JJJ'$m'~~'$i'~~    '$o'\\              '$t'Resolution: '$resolution $o'
       '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\             '$t'CPU: '$cpu $o'
      (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_          '$t'Threads: '$threads $o'
      '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__      '$t'Test'$o'
       '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\     '$t'Test'$o'
              '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)    '$t'Test'$o'
                          '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)   '$t'Test'$o'
                          (J'$m'JJ'$o'| \UUU)   '$t'Test'$o'
                           (UU)'(set_color normal)
end
