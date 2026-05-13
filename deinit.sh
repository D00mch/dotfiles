#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_PATH="$SCRIPT_DIR"
DRY_RUN=0
FAILED=0

usage() {
    cat <<EOF
Usage: bash deinit.sh [--dry-run] [DOTFILES_PATH]

Removes symlinks created by init.sh when they still point into DOTFILES_PATH.
DOTFILES_PATH defaults to this script's directory.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run|-n)
            DRY_RUN=1
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            DOTFILES_PATH="$1"
            ;;
    esac
    shift
done

abs_path() {
    local path="$1"
    local dir
    local base

    if [ -d "$path" ] && [ ! -L "$path" ]; then
        (cd "$path" 2>/dev/null && pwd -P)
        return
    fi

    dir="$(dirname "$path")"
    base="$(basename "$path")"
    (cd "$dir" 2>/dev/null && printf "%s/%s\n" "$(pwd -P)" "$base")
}

symlink_target_abs_path() {
    local link_path="$1"
    local target

    target="$(readlink "$link_path")"
    case "$target" in
        /*)
            abs_path "$target"
            ;;
        *)
            abs_path "$(dirname "$link_path")/$target"
            ;;
    esac
}

remove_owned_symlink() {
    local link_path="$1"
    local expected_target="$2"
    local actual_target
    local actual_target_abs
    local expected_target_abs
    local actual_target_label

    if [ ! -L "$link_path" ]; then
        echo "skip: $link_path is not a symlink"
        return
    fi

    actual_target="$(readlink "$link_path")"
    actual_target_abs="$(symlink_target_abs_path "$link_path")"
    expected_target_abs="$(abs_path "$expected_target")"
    actual_target_label="${actual_target_abs:-$actual_target}"

    if [ -z "$actual_target_abs" ] || [ -z "$expected_target_abs" ] || [ "$actual_target_abs" != "$expected_target_abs" ]; then
        echo "skip: $link_path points to $actual_target_label"
        return
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "would remove: $link_path"
    else
        if rm "$link_path"; then
            echo "removed: $link_path"
        else
            echo "failed: $link_path" >&2
            FAILED=1
        fi
    fi
}

DOTFILES_PATH="$(abs_path "$DOTFILES_PATH")"

remove_owned_symlink "$HOME/.vim" "$DOTFILES_PATH/.vim"
remove_owned_symlink "$HOME/.vimrc" "$DOTFILES_PATH/.vimrc"
remove_owned_symlink "$HOME/.zshenv" "$DOTFILES_PATH/.zshenv"
remove_owned_symlink "$HOME/.zshrc" "$DOTFILES_PATH/.zshrc"
remove_owned_symlink "$HOME/.ideavimrc" "$DOTFILES_PATH/.ideavimrc"
remove_owned_symlink "$HOME/.clojure" "$DOTFILES_PATH/.clojure"
remove_owned_symlink "$HOME/.wezterm.lua" "$DOTFILES_PATH/.wezterm.lua"

remove_owned_symlink "$HOME/.config/nvim" "$DOTFILES_PATH/.config/nvim"
remove_owned_symlink "$HOME/.config/clj-kondo" "$DOTFILES_PATH/.config/clj-kondo"
remove_owned_symlink "$HOME/.config/karabiner.edn" "$DOTFILES_PATH/.config/karabiner.edn"
remove_owned_symlink "$HOME/.config/aerospace" "$DOTFILES_PATH/.config/aerospace"
remove_owned_symlink "$HOME/.config/karabiner/assets" "$DOTFILES_PATH/.config/karabiner/assets"

remove_owned_symlink "$DOTFILES_PATH/.config/nvim/spell" "$DOTFILES_PATH/.vim/spell"

exit "$FAILED"
