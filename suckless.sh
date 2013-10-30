#!/bin/sh
set -e

sl_install()
{
  target="${1}-${2}"
  cd "$HOME"/tool/src
  tfile="$target".tar.gz
  if [ ! -r "$tfile" ]; then
    wget "$3" -O "$target".tar.gz
  fi
  cd "$HOME"/tool/build
  tar -xf "$HOME"/tool/src/"$tfile"
  cd "$target"
  if [ -e st.c ]; then
    patch -r - -p0 << EOT
--- config.def.h        2013-04-20 09:29:39.000000000 -0400
+++ config.def.h.new    2013-10-30 10:11:59.287727715 -0400
@@ -5,7 +5,7 @@
  *
  * font: see http://freedesktop.org/software/fontconfig/fontconfig-user.html
  */
-static char font[] = "Liberation Mono:pixelsize=12:antialias=false:autohint=false";
+static char font[] = "terminus:pixelsize=14:antialias=false:autohint=false";
 static int borderpx = 2;
 static char shell[] = "/bin/sh";

EOT
  fi
  make PREFIX="$HOME"/tool/install/"$target" install
  cd "$HOME"/tool/build
  rm -rf -- "$target"
  cd "$HOME"/tool/install
  stow "$target"
}

if ! which stow > /dev/null; then
  printf "Unable to locate stow\n" 1>&2
  exit 1
fi

mkdir -p tool/build tool/install tool/src
sl_install wmname 0.1 http://dl.suckless.org/tools/wmname-0.1.tar.gz
sl_install st 0.4.1 http://dl.suckless.org/st/st-0.4.1.tar.gz
# vim:set sw=2:
