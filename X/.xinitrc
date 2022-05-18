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

#export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/dbus-1"
export _JAVA_AWT_WM_NONREPARENTING=1
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

##############
# X settings #
##############

xsetroot -cursor_name left_ptr
xhost +si:localuser:root # to allow acpi handler to xautolock -locknow
#xset r rate 250 50;
# setxkbmap -option
# setxkbmap \
#   -layout us,gr \
#   -option grp:lalt_lshift_toggle \
#   -option caps:escape \
#   -option compose:ralt

#   -option ctrl:nocaps
# setxkbmap -option caps:swapescape 
# xcape  -e 'Control_L=Escape'

########
# Rice #
########

#dwmstatus &
# slstatus &
# ~/.fehbg &
[ -f ~/.config/xrdb/Xresources.xdefaults ] && \
    xrdb -merge -I"$HOME/.config/xrdb" ~/.config/xrdb/Xresources.xdefaults

################
# User Daemons #
################

activate-linux "Activate Linux" "Edit /etc/settings.d to activate" &
barrier &
# picon is picom-jonaburg
picom --experimental-backend -b &
~/bin/autoshutdown_on_low_power &
appimaged &
pulseaudio --start &
xautolock \
-locker 'slock -m  "$(cowsay $(fortune -s))"' \
-notify 300 \
-notifier "notify-send -u critical -t 15000 -- 'Locking screen in 5 minutes'" \
-time 30 \
-detectsleep &
    # 300 -> notify 5 mins before lock
    # 30 -> lock in 30 mins 
    # 15000 ms before msg disapears
# -locker 'slock -m  "Locked at $(date +%T)"' \

# start-pulseaudio-x11 --start &
# pavucontrol &

#############
# Traystart #
#############

blueman-tray &
udiskie --tray &
keepassxc &
# kdeconnect-app &
megasync &
nm-applet &
#nm-tray &

# start WM/DE                          \/ and extras
exec dbus-launch --exit-with-session startwm bspwm
