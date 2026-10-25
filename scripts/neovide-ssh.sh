#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: ${0##*/} <ssh-host> [remote-directory]

Open local Neovide with Neovim running over SSH.
Uses your SSH config; the directory defaults to the remote home directory.
Quote ~/ paths so they expand on the remote machine.

Examples:
  ${0##*/} mini
  ${0##*/} user@host '~/work/my project'
EOF
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac
if [[ $# -lt 1 || $# -gt 2 || -z "$1" || "$1" == -* ]]; then
  usage >&2
  exit 64
fi

remote_dir="${2:-.}"
case "$remote_dir" in
  '~') remote_dir=. ;;
  '~/'*) remote_dir="./${remote_dir#\~/}" ;;
esac
# SSH joins its command arguments into shell code; preserve literal path characters.
remote_dir=${remote_dir//\'/\'\\\'\'}

# --wsl enables Neovide's local clipboard integration for this remote Neovim.
# Neovide appends --embed to the SSH command, carrying RPC directly over stdio.
exec /usr/bin/open -n -a Neovide --args --no-fork --wsl --neovim-bin=/usr/bin/ssh -- \
  -T -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -- "$1" \
  "cd -- '$remote_dir' && exec /opt/homebrew/bin/nvim"
