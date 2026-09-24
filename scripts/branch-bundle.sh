#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 export <PROJECT_PATH_ENV_VAR> [output.bundle]" >&2
  echo "       $0 import <input.bundle> [new_branch_name]" >&2
  exit 64
}

fail() {
  echo "$*" >&2
  exit 1
}

case "${1:-}" in
  export)
    [[ $# -ge 2 && $# -le 3 ]] || usage
    project_env_var="$2"
    [[ "$project_env_var" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || fail "Invalid env var name: $project_env_var"
    project_path="${!project_env_var:-}"
    [[ -n "$project_path" ]] || fail "Env var $project_env_var is not set"
    project_path="$(git -C "$project_path" rev-parse --show-toplevel)"

    [[ "$(git -C "$project_path" rev-parse --is-shallow-repository)" == false ]] ||
      fail "A complete clone is required to export a self-contained bundle"
    branch_ref="$(git -C "$project_path" symbolic-ref --quiet HEAD)" ||
      fail "Detached HEAD; check out a branch first"
    git -C "$project_path" rev-parse --verify "$branch_ref^{commit}" >/dev/null ||
      fail "The current branch has no commits"
    branch="${branch_ref#refs/heads/}"
    output_path="${3:-$HOME/Downloads/$(basename "$project_path")-${branch//\//-}.bundle}"
    [[ "$output_path" == /* ]] || output_path="$PWD/$output_path"

    mkdir -p "$(dirname "$output_path")"
    git -C "$project_path" bundle create "$output_path" "$branch_ref"
    printf 'Bundle written to: %s\nBranch: %s\nIncludes committed history only.\n' "$output_path" "$branch"
    ;;
  import)
    [[ $# -ge 2 && $# -le 3 ]] || usage
    [[ "$(git rev-parse --is-inside-work-tree)" == true ]] ||
      fail "Run import from the destination repository"
    bundle_path="$2"
    [[ "$bundle_path" == /* ]] || bundle_path="$PWD/$bundle_path"
    git bundle verify "$bundle_path"
    branch_ref="$(git bundle list-heads "$bundle_path" | awk '$2 ~ /^refs\/heads\// {print $2}')"
    [[ -n "$branch_ref" && "$branch_ref" != *$'\n'* ]] ||
      fail "Expected a bundle containing exactly one branch"
    branch="${3:-${branch_ref#refs/heads/}}"
    [[ "$branch" != -* ]] && git check-ref-format "refs/heads/$branch" ||
      fail "Invalid branch name: $branch"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      fail "Branch '$branch' already exists; pass a different new_branch_name"
    fi

    git fetch --no-tags -- "$bundle_path" "$branch_ref:refs/heads/$branch"
    printf 'Created branch: %s\nSwitch to it with: git switch %q\n' "$branch" "$branch"
    ;;
  *) usage ;;
esac
