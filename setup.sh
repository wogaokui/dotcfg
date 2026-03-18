#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

for dir in */; do
    stow -R -t "$HOME" "$dir"  # Restow 到 $HOME，避免受当前工作目录影响
done
