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


# rm -f ~/.dbus-address
# dbus-launch --exit-with-x11 > ~/.dbus-address
# . ~/.dbus-address
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
export DBUS_SESSION_BUS_ADDRESS
# export DBUS_SESSION_BUS_PID
# export DBUS_SESSION_BUS_WINDOWID


exec startwm
