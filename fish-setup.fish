# Fish Setup

echo "[Setting up fish]"

echo "[Adding Config]"
curl https://cdn.staticaly.com/gh/Kixiron/dotfiles/0e0e9d4c/fish-config.fish > "$__fish_config_dir/config.fish"

echo "[Adding Prompt]"
curl https://cdn.staticaly.com/gh/Kixiron/dotfiles/0e0e9d4c/fish-prompt.fish > "$__fish_config_dir/functions/fish_prompt.fish"

echo "[Setting Fish to Default Shell]"
fish --login

echo "[Done setting up fish]"
