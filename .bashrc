# shellcheck shell=bash
export PATH="$HOME/dmp/bin:$HOME/.local/bin:$PATH" XDG_CONFIG_HOME="$HOME/.config" EDITOR=vim VISUAL=vim

[[ $- == *i* ]] || return

alias ls='ls --color=auto' grep='grep --color=auto'

_gp()
{
    local b l d=0 s=0
    b=$(git branch --show-current 2>/dev/null)
    [[ -n $b ]] || return 0
    while IFS= read -r l; do
        [[ ${l:0:1} != [' ?'] ]] && s=1
        [[ ${l:1:1} != ' ' ]] && d=1
    done < <(git status --porcelain 2>/dev/null)
    printf ' (%s)' "$b"
    ((d)) && printf '\001\e[31m\002 *\001\e[0m\002'
    ((s)) && printf '\001\e[32m\002 +\001\e[0m\002'
    return 0
}

_g=''
PROMPT_COMMAND='_g=$(_gp)'
PS1="\[\e[$((EUID ? 32 : 31))m\]->\[\e[0m\] \[\e[1;36m\]\W\[\e[0m\]\$_g >> "

for f in "$HOME/.bashrc.d"/*; do
    [[ -f $f ]] && . "$f"
done
unset f
