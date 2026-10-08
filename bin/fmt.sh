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

(($#)) || die "usage: ${0##*/} <path>..."
need jq shfmt

while IFS= read -r -d '' f; do
    case $f in
    *.json)
        o=$(jq -c . "$f")
        printf '%s\n' "$o" >"$f"
        ;;
    *) shfmt -ln bash -i 4 -fn -s -w "$f" ;;
    esac
done < <(find "$@" -name .git -prune -o -type f \
    \( -name '*.sh' -o -name .bashrc -o -name .bash_profile -o -name '*.json' \) -print0)
