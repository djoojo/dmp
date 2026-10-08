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

sudo -v 2>/dev/null || { printf 'warning: no root, skipping sbin\n' >&2; exit 0; }

for f in sbin/*.sh; do
    t=/usr/local/sbin/$(basename "$f" .sh)
    sudo cp "$f" "$t"
    sudo chmod +x "$t"
done
