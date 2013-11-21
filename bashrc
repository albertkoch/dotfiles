# vim:sw=2
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

unalias -a
alias ll='ls -Al'
set -o vi

HISTCONTROL=ignoredups
LANG=C
if which vim > /dev/null 2>&1; then
  EDITOR=vim
  alias vi=vim
else
  EDITOR=vi
fi
PAGER=less
LESSHISTFILE=-

# Bash specific section
if [ ! -z "$BASH" ]; then
  if [ `id -u` -eq 0 ]; then
    PS1="\[\e[0;31m\]\u@\h \[\e[1;34m\]\W {\!}# \[\e[0m\]"
  else
    PS1="\[\e[0;32m\]\u@\h \[\e[1;34m\]\W {\!}$ \[\e[0m\]"
  fi
  shopt -s checkwinsize
else
  if [ `id -u` -eq 0 ]; then
    PS1="${USER}@`hostname` \\# "
  else
    PS1="${USER}@`hostname` \\$ "
  fi
fi

PS1_DOTFILES="\[\e[1;31m\]\$(${HOME}/.dotfiles/update.sh)\[\e[0m\]"
PS1_CHROOT="${debian_chroot:+\[\e[1;31m\]($debian_chroot) \[\e[0m\]}"
PS1_PROMPT="\[\e[0;32m\]\u@\h \[\e[1;34m\]\W $ \[\e[0m\]"
PS1="${PS1_DOTFILES}${PS1_CHROOT}${PS1_PROMPT}"
LEDGER_FILE=ledger.ldg

export HISTCONTROL
export PS1
export LANG
export EDITOR
export PAGER
export LESSHISTFILE
export LEDGER_FILE
