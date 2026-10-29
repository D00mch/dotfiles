#!/usr/bin/env bash

set -euo pipefail

DOTFILES_PATH="$(cd "${1:-$(dirname "${BASH_SOURCE[0]}")}" && pwd -P)"

rm_symlink() {
    local path="$1" target
    shift
    for target; do
        if [[ -L "$path" && ( "$path" -ef "$target" || "$(readlink "$path")" == "$target" ) ]]; then
            rm "$path"
            echo "removed: $path"
            return
        fi
    done
}

for name in .vim .vimrc .zshenv .zshrc .ideavimrc .clojure .wezterm.lua; do
    rm_symlink "$HOME/$name" "$DOTFILES_PATH/$name"
done

for name in nvim clj-kondo karabiner.edn aerospace neru karabiner/assets; do
    rm_symlink "$HOME/.config/$name" "$DOTFILES_PATH/.config/$name"
done
rm_symlink "${XDG_CONFIG_HOME:-$HOME/.config}/neovide" \
    "${XDG_STATE_HOME:-$HOME/.local/state}/neovide" "$DOTFILES_PATH/.config/neovide"

rm_symlink "$DOTFILES_PATH/.config/nvim/spell" "$DOTFILES_PATH/.vim/spell"
