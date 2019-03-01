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

# Programming
abbr --add --global py python3
abbr --add --global rustrun (clear; cargo run)

# Git
abbr --add --global gpull git pull
abbr --add --global gpush git push
abbr --add --global gco git checkout
abbr --add --global gcom git commit

# Startup Message
set o (set_color $_dark_blue)
set m (set_color $_purple)
set i (set_color $_cyan)
set fish_greeting '                 '$o'___                        Test
  ___======____='$m'-'$i'-'$m'-='$o')                   Test
/T            \_'$i'--='$m'=='$o')                  Test
''['' \ '$m'('$i'O'$m')   '$o'\~    \_'$i'-='$m'='$o')             Test
 \      / )J'$m'~~    '$o'\\'$i'-='$o')             Test
  \\\\___/  )JJ'$m'~'$i'~~   '$o'\)              Test
   \_____/JJJ'$m'~~'$i'~~    '$o'\\             Test
   '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\            Test
  (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_         Test      
  '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__     Test        
   '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\    Test     
          '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)   Test
                      '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)  Test
                      (J'$m'JJ'$o'| \UUU)  Test
                       (UU)    Test'
