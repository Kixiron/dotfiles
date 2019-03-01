# Fish Setup

echo "[Setting up fish]"

echo "[Adding Config]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish-config.fish > "$__fish_config_dir/config.fish"

echo "[Adding Prompt]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish-prompt.fish > "$__fish_config_dir/functions/fish_prompt.fish"

echo "[Adding Title]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish-title.fish > "$__fish_config_dir/functions/fish_title.fish"

echo "[Adding Greeting]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish-greeting.fish > "$__fish_config_dir/functions/fish_greeting.fish"

echo "[Setting Fish to Default Shell]"
fish --login

echo "[Done setting up fish]"
