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
set text (set_color $_orange)
set fish_greeting '                 '$outer'___               '$text'Test'$outer'
  ___======____='$middle'-'$inner'-'$middle'-='$outer')              '$text'Test'$outer'
/T            \_'$inner'--='$middle'=='$outer')             '$text'Test'$outer'
''['' \ '$middle'('$inner'O'$middle')   '$outer'\~    \_'$inner'-='$middle'='$outer')             '$text'Test'$outer'
 \      / )J'$middle'~~    '$outer'\\'$inner'-='$outer')             '$text'Test'$outer'
  \\\\___/  )JJ'$middle'~'$inner'~~   '$outer'\)              '$text'Test'$outer'
   \_____/JJJ'$middle'~~'$inner'~~    '$outer'\\             '$text'Test'$outer'
   '$middle'/ '$outer'\  '$inner', \\'$outer'J'$middle'~~~'$inner'~~     '$middle'\\            '$text'Test'$outer'
  (-'$inner'\)'$outer'\='$middle'|'$inner'\\\\\\'$middle'~~'$inner'~~       '$middle'L_'$inner'_         '$text'Test'$outer'
  '$middle'('$outer'\\'$middle'\\)  ('$inner'\\'$middle'\\\)'$outer'_           '$inner'\=='$middle'__     '$text'Test'$outer'
   '$outer'\V    '$middle'\\\\'$outer'\) =='$middle'=_____   '$inner'\\\\\\\\'$middle'\\\\    '$text'Test'$outer'
          '$outer'\V)     \_) '$middle'\\\\'$inner'\\\\JJ\\'$middle'J\)   '$text'Test'$outer'
                      '$outer'/'$middle'J'$inner'\\'$middle'J'$outer'T\\'$middle'JJJ'$outer'J)  '$text'Test'$outer'
                      (J'$middle'JJ'$outer'| \UUU)  '$text'Test'$outer'
                       (UU)        '$text'Test'
