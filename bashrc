set -o vi
export EDITOR=`which vi`
export LESSHISTFILE=-
export PS1="${debian_chroot:+\[\e[1;31m\]($debian_chroot) }\[\e[0;32m\]\u@\h \[\e[1;34m\]\W $ \[\e[0m\]"
