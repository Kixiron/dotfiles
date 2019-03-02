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
    set uptime (uptime -p)
    set cpu (lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{ $1=$1 } 1')
    set threads (nproc)
    set total_mem (free | awk '/^Mem:/ { print int($2 / 1000000) }')

    echo '                 '$o'___
      ___======____='$m'-'$i'-'$m'-='$o')               
    /T            \_'$i'--='$m'=='$o')              
    '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')              '$t$user'@'$host $o'
     \      / )J'$m'~~    '$o'\\'$i'-='$o')              '$t'OS: '$os $o'
      \\\\___/  )JJ'$m'~'$i'~~   '$o'\)               '$t'CPU: '$cpu $o'
       \_____/JJJ'$m'~~'$i'~~    '$o'\\              '$t'Threads: '$threads $o'
       '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\             '$t'Memory: '$total_mem'gb' $o'
      (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_          '$t'Resolution: '$resolution $o'
      '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__      
       '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\     
              '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)    
                          '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)   
                          (J'$m'JJ'$o'| \UUU)   
                           (UU)'(set_color normal)
end
