#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <PROJECT_PATH_ENV_VAR> [output_patch_path]" >&2
  echo "Example: $0 THE_PATH ~/Downloads/tmp" >&2
  exit 64
fi

project_env_var="$1"
output_path="${2:-$HOME/Downloads/tmp}"

if [[ ! "$project_env_var" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
  echo "Invalid env var name: $project_env_var" >&2
  exit 64
fi

project_path="${!project_env_var:-}"

if [[ -z "$project_path" ]]; then
  echo "Env var $project_env_var is not set" >&2
  exit 1
fi

if [[ ! -d "$project_path/.git" ]]; then
  echo "$project_path is not a git repository" >&2
  exit 1
fi

cd "$project_path"

if [[ -z "$(git status --porcelain)" ]]; then
  echo "No changes to commit" >&2
  exit 1
fi

git add -A

if git diff --binary --cached | grep -Eiq '\bcodex\b'; then
  echo "Uncommitted changes contain Codex work" >&2
  exit 1
fi

git commit -m "tmp"

commit_hash="$(git rev-parse --verify HEAD)"

mkdir -p "$(dirname "$output_path")"
git diff --binary "${commit_hash}^!" > "$output_path"

echo "Created tmp commit: $commit_hash"
echo "Patch written to: $output_path"
