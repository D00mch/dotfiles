#!/usr/bin/env bash

set -euo pipefail

repo="$(cd "${1:-$(dirname "${BASH_SOURCE[0]}")/..}" && pwd -P)"
config="${XDG_CONFIG_HOME:-$HOME/.config}/neovide"
state="${XDG_STATE_HOME:-$HOME/.local/state}/neovide"

if [[ -e "$config" || -L "$config" ]]; then
  if [[ ! -L "$config" ]] || [[ ! "$config" -ef "$repo/.config/neovide" &&
      ! "$config" -ef "$state" && "$(readlink "$config")" != "$state" ]]; then
    echo "Leaving existing Neovide configuration untouched: $config" >&2
    exit 1
  fi
fi

mkdir -p "$(dirname "$config")" "$state"
if [[ ! -e "$state/config.toml" ]]; then
  # On migration, the repository file still contains the current font selection.
  cp "$repo/.config/neovide/config.toml" "$state/config.toml"
fi
if [[ ! "$config" -ef "$state" ]]; then ln -sfn "$state" "$config"; fi
