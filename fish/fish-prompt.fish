# ~/.config/fish/functions/fish_prompt.fish

# Fish Prompt
function fish_prompt
    # Set Error
    set fish_color_error $color_red

    # Set Top Prompt
    set_color $color_cyan
    echo -n $user
    set_color $color_pink
    echo -n "@"
    set_color $color_cyan
    echo -n $host
    set_color $color_dark_blue
    echo -n " ["
    set_color $color_purple
    echo -n (printf (date "+$c2%H$c0:$c2%M$c0:$c2%S"))
    set_color $color_dark_blue
    echo "]"

    # Prompt
    set_color $color_dark_blue
    echo -n (pwd)
    set_color $color_pink
    echo -n " ~> "

    # Set Final Text Color
    set_color $color_purple
end
