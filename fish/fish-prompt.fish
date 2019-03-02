# ~/.config/fish/functions/fish_prompt.fish

# Fish Prompt
function fish_prompt
    # Set Error
    set fish_color_error $_red

    # Set Top Prompt
    set_color $_cyan
    echo -n $user
    set_color $_pink
    echo -n "@"
    set_color $_cyan
    echo -n $host
    set_color $_dark_blue
    echo -n " ["
    set_color $_purple
    echo -n (printf (date "+$c2%H$c0:$c2%M$c0:$c2%S"))
    set_color $_dark_blue
    echo "]"

    # Prompt
    set_color $_dark_blue
    echo -n (pwd)
    set_color $_pink
    echo -n " ~> "

    # Set Final Text Color
    set_color $_purple
end
funcsave fish_prompt
