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

# Startup Message
set outer (set_color $_dark_blue)
set middle (set_color $_purple)
set inner (set_color $_cyan)
set text (set_color $_pink)
set fish_greeting '                 '$outer'___               '$text'User: $user'$outer'
  ___======____='$middle'-'$inner'-'$middle'-='$outer')              '$text'Host: $host'$outer'
/T            \_'$inner'--='$middle'=='$outer')             '$text'Test'$outer'
''['' \ '$middle'('$inner'O'$middle')   '$outer'\~    \_'$inner'-='$middle'='$outer')             '$text'Editor: $EDITOR'$outer'
 \      / )J'$middle'~~    '$outer'\\'$inner'-='$outer')             '$text'Time: (printf (date "+$c2%H$c0:$c2%M$c0:$c2%S"))'$outer'
  \\\\___/  )JJ'$middle'~'$inner'~~   '$outer'\)              '$text'Home Directory: $HOME'$outer'
   \_____/JJJ'$middle'~~'$inner'~~    '$outer'\\             '$text'Test'$outer'
   '$middle'/ '$outer'\  '$inner', \\'$outer'J'$middle'~~~'$inner'~~     '$middle'\\            '$text'Fish Version: $FISH_VERSION'$outer'
  (-'$inner'\)'$outer'\='$middle'|'$inner'\\\\\\'$middle'~~'$inner'~~       '$middle'L_'$inner'_         '$text'Kernel: $uname'$outer'
  '$middle'('$outer'\\'$middle'\\)  ('$inner'\\'$middle'\\\)'$outer'_           '$inner'\=='$middle'__     '$text'Network: (uname -n)'$outer'
   '$outer'\V    '$middle'\\\\'$outer'\) =='$middle'=_____   '$inner'\\\\\\\\'$middle'\\\\    '$text'CPU Load: (top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')'$outer'
          '$outer'\V)     \_) '$middle'\\\\'$inner'\\\\JJ\\'$middle'J\)   '$text'Processes Running: (grep 'procs_running' /proc/stat)'$outer'
                      '$outer'/'$middle'J'$inner'\\'$middle'J'$outer'T\\'$middle'JJJ'$outer'J)  '$text'Free Memory: (free -m | awk 'NR==2{printf "%.2f%%\t\t", $3 * 100 / $2}')'$outer'
                      (J'$middle'JJ'$outer'| \UUU)  '$text'Disk Space Used: (df -h | awk '$NF=="/"{printf "%s\t\t", $5}')'$outer'
                       (UU)        '$text'Test'
