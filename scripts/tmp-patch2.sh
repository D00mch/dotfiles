#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/master}"
output_path="${2:-$HOME/Downloads/logs}"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a git repository" >&2
  exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [[ "$current_branch" == "HEAD" ]]; then
  echo "Detached HEAD; checkout a branch first" >&2
  exit 1
fi

if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
  echo "Base ref does not exist locally: $base_ref" >&2
  echo "Try: git fetch origin master" >&2
  exit 1
fi

mkdir -p "$(dirname "$output_path")"

git diff "${base_ref}..${current_branch}" > "$output_path"

echo "Diff written to: $output_path"
echo "Compared: $base_ref..$current_branch"
