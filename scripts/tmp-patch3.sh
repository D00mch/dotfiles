#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/master}"
output_path="${2:-$HOME/Downloads/logs}"
commit_path="${3:-$HOME/Documents/tmpcommit}"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a git repository" >&2
  exit 1
fi

if [[ ! -f "$commit_path" ]]; then
  echo "Commit file does not exist: $commit_path" >&2
  exit 1
fi

previous_commit="$(tr -d '[:space:]' < "$commit_path")"

if [[ -z "$previous_commit" ]]; then
  echo "Commit file is empty: $commit_path" >&2
  exit 1
fi

if ! git rev-parse --verify "${previous_commit}^{commit}" >/dev/null 2>&1; then
  echo "Stored commit does not exist locally: $previous_commit" >&2
  exit 1
fi

if ! git rev-parse --verify "${base_ref}^{commit}" >/dev/null 2>&1; then
  echo "Base ref does not exist locally: $base_ref" >&2
  echo "Try: git fetch origin master" >&2
  exit 1
fi

new_commit="$(git rev-parse --verify "${base_ref}^{commit}")"

mkdir -p "$(dirname "$output_path")"
mkdir -p "$(dirname "$commit_path")"

{
  echo "Commits from $previous_commit to $new_commit ($base_ref):"
  git log --oneline --decorate "${previous_commit}..${base_ref}"
  echo
  echo "Diff from $previous_commit to $base_ref:"
  git diff "${previous_commit}...${base_ref}" -- . ':(exclude)admin_spa/**'
} > "$output_path"

printf '%s\n' "$new_commit" > "$commit_path"

echo "Logs written to: $output_path"
echo "Stored latest $base_ref commit: $new_commit"
