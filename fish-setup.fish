# Fish Setup

echo "[Setting up fish]"

curl https://cdn.staticaly.com/gist/Kixiron/e8416829fe13fd5f7da5af8d81afd952/raw/df71859ab57a6b22320bdc60839a7fc9876d88ac/fish-config.fish > "$__fish_config_dir/config.fish"
curl https://cdn.staticaly.com/gist/Kixiron/e8416829fe13fd5f7da5af8d81afd952/raw/df71859ab57a6b22320bdc60839a7fc9876d88ac/fish-prompt.fish > "$__fish_config_dir/functions/fish_prompt.fish"

fish --login
set -U EDITOR code

echo "[Done setting up fish]"
