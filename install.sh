#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

cp .bashrc .tmux.conf ~
mkdir -p ~/.local/bin

for f in bin/*.sh; do
    t=~/.local/bin/$(basename "$f" .sh)
    cp "$f" "$t"
    chmod +x "$t"
done
