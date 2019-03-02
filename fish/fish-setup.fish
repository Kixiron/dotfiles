# Fish Setup
echo "[Setting Up Fish]"

echo "[Adding Config]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-config.fish > "$__fish_config_dir/config.fish"

echo "[Adding Prompt]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-prompt.fish > "$__fish_config_dir/functions/fish_prompt.fish"

echo "[Adding Title]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-title.fish > "$__fish_config_dir/functions/fish_title.fish"

echo "[Setting Fish to Default Shell]"
fish --login

echo "[Done Setting Up Fish]"
