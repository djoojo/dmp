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
    for c; do command -v -- "$c" >/dev/null || die "$c is not installed"; done
}

mk()
{
    tmux new -ds "$s"
    for _ in 2 3; do tmux neww -dt "$s:"; done
}

(($# <= 1)) || die "usage: ${0##*/} [name]"
need tmux fzf

if (($#)); then
    s=$1
    tmux has -t="$s" 2>/dev/null || mk
else
    tmux has 2>/dev/null || die 'no running sessions'
    s=$(tmux ls -F '#S' | fzf --layout=reverse) || exit 0
fi

[[ -z ${TMUX-} ]] || exec tmux switch -t="$s"
exec tmux attach -t="$s"
