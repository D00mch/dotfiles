#!/usr/bin/env bash

set -u

DOTFILES_PATH="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)}"

rm_symlink() {
    local path="$1"

    if [ -L "$path" ]; then
        rm "$path"
        echo "removed: $path"
    else
        echo "skip: $path is not a symlink"
    fi
}

rm_symlink "$HOME/.vim"
rm_symlink "$HOME/.vimrc"
rm_symlink "$HOME/.zshenv"
rm_symlink "$HOME/.zshrc"
rm_symlink "$HOME/.ideavimrc"
rm_symlink "$HOME/.clojure"
rm_symlink "$HOME/.wezterm.lua"

rm_symlink "$HOME/.config/nvim"
rm_symlink "$HOME/.config/neovide"
rm_symlink "$HOME/.config/clj-kondo"
rm_symlink "$HOME/.config/karabiner.edn"
rm_symlink "$HOME/.config/aerospace"
rm_symlink "$HOME/.config/karabiner/assets"

rm_symlink "$DOTFILES_PATH/.config/nvim/spell"
