#!/usr/bin/env bash
set -euo pipefail
die()
{
printf 'error: %s\n' "$1" >&2
exit 1
}
need()
{
local c
for c in "$@";do
command -v "$c" >/dev/null||die "$c is not installed"
done
}
m()
{
local f in
cd "$(dirname "$0")"
need tmux fzf
cp bashrc "$HOME/.bashrc"
cp tmux.conf "$HOME/.tmux.conf"
for f in bin/*;do
install -Dm755 "$f" "$HOME/.local/bin/${f##*/}"
done
if ((EUID));then
read -rp 'install sbin (needs root)? [y/N] ' in
[[ $in == [yY] ]]||exit 0
sudo -v||die 'no root access'
fi
for f in sbin/*;do
sudo install -Dm755 "$f" "/usr/local/sbin/${f##*/}"
done
}
m "$@"
