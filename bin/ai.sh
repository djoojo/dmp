#!/usr/bin/env bash
set -euo pipefail

img=claude-code

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

build()
{
    local c
    need buildah
    c=$(buildah from docker.io/library/debian:trixie-slim)
    buildah run "$c" -- sh -c '
        set -e
        apt-get update
        apt-get install -y --no-install-recommends ca-certificates curl git
        useradd -m -u 1000 -s /bin/bash claude
    '
    buildah config --cmd '' "$c"
    buildah config \
        --user claude \
        --env HOME=/home/claude \
        --env PATH=/home/claude/.local/bin:/usr/bin \
        --env CLAUDE_CONFIG_DIR=/home/claude/.claude \
        --env DISABLE_AUTOUPDATER=1 \
        --entrypoint '["claude"]' \
        "$c"
    buildah run "$c" -- bash -c 'set -o pipefail; curl -fsSL https://claude.ai/install.sh | bash'
    buildah commit --rm "$c" "$img"
}

need podman
[[ $PWD != "$HOME" && $PWD != / ]] || die "refusing to mount $PWD"
podman image exists "$img" || build

exec podman run --rm -it \
    --userns=keep-id:uid=1000,gid=1000 \
    -v "$PWD:$PWD" -w "$PWD" \
    -v claude-config:/home/claude/.claude \
    "$img" "$@"
