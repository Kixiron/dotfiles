# Fish Setup
echo "[Setting Up Fish]"
cd $__fish_config_dir
mkdir ./functions

echo "[Adding Config]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-config.fish > "./config.fish"

echo "[Adding Prompt]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-prompt.fish > "./functions/fish_prompt.fish"

echo "[Adding Title]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-title.fish > "./functions/fish_title.fish"

echo "[Adding Greeting]"
curl https://raw.githubusercontent.com/Kixiron/dotfiles/master/fish/fish-greeting.fish > "./functions/fish_greeting.fish"

echo "[Setting Fish to Default Shell]"
fish --login

cd /
echo "[Done Setting Up Fish]"
