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

ok()
{
    local r
    read -rp "$1 [y/N] " r
    [[ $r == [yY] ]]
}

(($# == 2)) || die "usage: ${0##*/} <device> <label>"
((EUID == 0)) || die 'run as root'
need mkfs.exfat udevadm

d=$1
l=$2
[[ -b $d ]] || die "$d is not a block device"
[[ $(lsblk -dnro TRAN "$d") == usb ]] || die "$d is not a usb device"
((${#l} <= 11)) || die 'label is longer than 11 characters'
[[ $d == *[0-9] ]] && p=${d}p1 || p=${d}1

lsblk -o NAME,SIZE,MODEL,LABEL,MOUNTPOINTS "$d"
ok "erase $d?" || exit 0

umount "$d"?* 2>/dev/null || true
wipefs -aq "$d"
sfdisk -q -X gpt "$d" <<<'type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7'
udevadm settle
mkfs.exfat -L "$l" "$p"
sync
