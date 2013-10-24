set -o vi
export EDITOR=`which vi`
export LESSHISTFILE=-

SCRIPT=$(readlink -f "$1")
SCRIPT_DIR=$(dirname "$SCRIPT")

PS1_DOTFILES="\[\e[1;31m\]\$(${SCRIPT_DIR}/update.sh)\[\e[0m\]"
PS1_CHROOT="${debian_chroot:+\[\e[1;31m\]($debian_chroot) \[\e[0m\]}"
PS1_PROMPT="\[\e[0;32m\]\u@\h \[\e[1;34m\]\W $ \[\e[0m\]"
export PS1="${PS1_DOTFILES}${PS1_CHROOT}${PS1_PROMPT}"
