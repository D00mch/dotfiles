#!/usr/bin/env bash

set -euo pipefail

DOTFILES_PATH="$(cd "${1:-$(dirname "${BASH_SOURCE[0]}")}" && pwd -P)"

link() {
    local source="$1" target="$2"
    if [[ -L "$target" && "$target" -ef "$source" ]]; then return; fi
    if [[ -e "$target" || -L "$target" ]]; then
        echo "Refusing to replace existing path: $target" >&2
        return 1
    fi
    ln -s "$source" "$target"
}

for name in .vim .vimrc .zshenv .zshrc .ideavimrc .clojure .wezterm.lua; do
    link "$DOTFILES_PATH/$name" "$HOME/$name"
done
touch "$HOME/.ssh-aliases.sh" # zshrc sources it
mkdir -p "$HOME/.config/karabiner"

for name in nvim clj-kondo karabiner.edn aerospace neru karabiner/assets; do
    link "$DOTFILES_PATH/.config/$name" "$HOME/.config/$name"
done
bash "$DOTFILES_PATH/scripts/setup-neovide.sh" "$DOTFILES_PATH"
cp -R "$DOTFILES_PATH/.config/zathura" "$HOME/.config/"

# Keep Neovim spell data available from stdpath("config")/spell.
link "$DOTFILES_PATH/.vim/spell" "$DOTFILES_PATH/.config/nvim/spell"
