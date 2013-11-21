#!/bin/sh

addPath()
{
  if [ -d "$1" ]; then
    PATH="$PATH:$1"
  fi
}
PATH=""
for i in bin tool/bin tool/sbin; do
  addPath "$HOME"/"$i"
done
for base in /usr/local /usr/X11R6 /usr ""; do
  for d in bin sbin; do
    addPath "$base"/"$d"
  done
done
unset -f addPath
PATH=${PATH#:}

AMANPATH=tool/share
export AMANPATH PATH

if [ -f "$HOME"/.bashrc ]; then
  . "$HOME"/.bashrc
fi
