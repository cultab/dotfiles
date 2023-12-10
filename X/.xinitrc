#!/bin/sh
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -n "$1" ]; then
    return;
fi

export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

dbus-launch --exit-with-x11 > ~/.dbus-address
. ~/.dbus-address

exec startwm
