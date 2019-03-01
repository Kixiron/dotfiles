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

    # Set Prompt
    set -l command (echo $_)
    if test $command = "fish"
        if git rev-parse --git-dir > /dev/null ^ /dev/null
            set -l git_dir (git rev-parse --git-dir)
            if test $git_dir = ".git"
                set_color $_green
                echo -n (basename)
                set_color $_dark_blue
                echo -n (pwd)
            else
                set_color $_green
                echo -n (basename)
                set_color $_dark_blue
                echo -n (dirname $git_dir)
            end
        else
            set_color $_dark_blue
            echo -n (pwd)
        end
    else
        set_color $_dark_blue
        echo -n (pwd)
    end
    set_color $_pink
    echo -n " ~> "

    # Set Final Text Color
    set_color $_purple
end
funcsave fish_prompt
