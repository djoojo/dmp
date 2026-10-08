#!/usr/bin/env bash
set -euo pipefail

fg()
{
    local c
    for c; do printf '\e[%sm%4s\e[0m' "$c" "$c"; done
    echo
}

bg()
{
    printf '\e[%sm    \e[0m' "$@"
    echo
}

n()
{
    printf '%4s' "$@"
    echo
}

fg {30..37}
fg {90..97}
echo
n {40..47}
bg {40..47}
bg {100..107}
n {100..107}
