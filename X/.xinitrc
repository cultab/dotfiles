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

xhost +localhost # to allow acpi handler to xautolock -locknow
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
slstatus &
~/.fehbg &
[ -f ~/.config/xrdb/Xresources.xdefaults ] && \
    xrdb -merge -I"$HOME/.config/xrdb" ~/.config/xrdb/Xresources.xdefaults

###########
# Daemons #
###########

~/bin/autoshutdown_on_low_power &
appimaged &
#barrierc --daemon --no-tray --restart --enable-crypto 192.168.1.120 &
barrier &
#compton -b &
picom -b --corner-radius 7 &
# 300 -> notify 5 mins before lock
# 30 -> lock in 30 mins 
# 15000 ms before msg disapears
    # -locker 'slock -m  "Locked at $(date +%T)"' \
xautolock \
-locker 'slock -m  "$(cowsay -f $(fd .cow ~/.cowsay/ | shuf -n 1) $(fortune -s))"' \
-notify 300 \
-notifier "notify-send -u critical -t 15000 -- 'Locking screen in 5 minutes'" \
-time 30 &

#########
# Audio #
#########

pulseaudio --start &
start-pulseaudio-x11 --start &
pavucontrol &

#############
# Autostart #
#############

kdeconnect-app &
blueman-manager &
megasync &
#flatpak run com.discordapp.Discord NEEDS DBUS?
#nm-tray &
#blueman-applet &

# start WM/DE
exec dbus-launch --exit-with-session dwm

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
