#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

exec ~/.config/aerospace/center-floating.sh "$@"
