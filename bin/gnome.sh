#!/usr/bin/env bash
set -euo pipefail

g()
{
    gsettings set "$@"
}
kb=org.gnome.desktop.wm.keybindings

g org.gnome.mutter dynamic-workspaces false
g org.gnome.desktop.wm.preferences num-workspaces 5
g org.gnome.shell.extensions.dash-to-dock hot-keys false 2>/dev/null || true
g org.gnome.desktop.interface show-battery-percentage true
g "$kb" close "['<Super>c']"

for i in {1..9}; do
    g org.gnome.shell.keybindings "switch-to-application-$i" '[]'
done

for i in {1..5}; do
    g "$kb" "switch-to-workspace-$i" "['<Super>$i']"
    g "$kb" "move-to-workspace-$i" "['<Super><Shift>$i']"
done
