#!/bin/sh

addPath()
{
  if [ -d "$1" ]; then
    PATH="$PATH:$1"
  fi
}
PATH=""
for i in bin .software/bin .software/sbin .rvm/bin; do
  addPath "$HOME"/"$i"
done
for base in /usr/local /usr/X11R6 /usr ""; do
  for d in bin sbin; do
    addPath "$base"/"$d"
  done
done
unset -f addPath
PATH=${PATH#:}

export PATH

if [ ! -z "$BASH" ]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

if [ -f "$HOME"/.bashrc ]; then
  . "$HOME"/.bashrc
fi
