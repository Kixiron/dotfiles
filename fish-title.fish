# Fish Title

function fish_title
    set -l command (echo $_)

    if test $command = "fish"
        # we are sitting at the fish prompt

        if git rev-parse --git-dir > /dev/null ^ /dev/null
            # we are inside a git directory, so use the name of the repo as the terminal title

            set -l git_dir (git rev-parse --git-dir)
            if test $git_dir = ".git"
                # we are at the root of the git repo
                echo (basename (pwd))
            else
                # we are at least one level deep in the git repo
                echo (basename (dirname $git_dir))
            end
        else
            # we are NOT inside a git repo, so just use the working-directory
            echo (pwd)
        end
    else
        # we are busy running some non-fish command, so use the command name
        echo $command
    end
end
funcsave fish_title
