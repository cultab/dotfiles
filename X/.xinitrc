#!/bin/sh
#
# ~/.xinitrc
#
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

###########
# Daemons #
###########

barrier &
~/bin/autoshutdown_on_low_power &
appimaged &
# poweralertd 2> ~/log &
# (sleep 5m && poweralertd) &
#barrierc --daemon --no-tray --restart --enable-crypto 192.168.1.120 &
# sxhkd &
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

#########
# Audio #
#########

pulseaudio --start &
# start-pulseaudio-x11 --start &
pavucontrol &

#############
# Autostart #
#############

udiskie --tray &
# picon is picom-jonaburg
picom --experimental-backend -b &
keepassxc &
# (sleep 5m && flatpak run com.discordapp.Discord) &
kdeconnect-app &
blueman-manager &
megasync &
#nm-tray &
nm-applet &
#blueman-applet &

# start WM/DE
exec dbus-launch --exit-with-session startwm bspwm

#case "$1" in
#dwm)
#    exec dwm
#    ;;
#xfce)
#    exec startxfce4
#    ;;
#*)
#    exec dwm
#    ;;
#esac
