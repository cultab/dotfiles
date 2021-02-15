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

############
# keyboard #
############

setxkbmap -layout us,gr
setxkbmap -option grp:lalt_lshift_toggle
#setxkbmap -option caps:swapescape 
setxkbmap -option ctrl:nocaps
setxkbmap -option compose:ralt
xset r rate 250 50;


########
# Rice #
########

dwmstatus &
~/.fehbg &
[ -f ~/.config/xrdb/Xresources.xdefaults ] && \
    xrdb -merge -I"$HOME/.config/xrdb" ~/.config/xrdb/Xresources.xdefaults

###########
# Daemons #
###########

xcape  -e 'Super_L=Super_L|R'
xcape -e 'Control_L=Escape'
compton -b &
# 300 -> notify 5 mins before lock, 10 -> lock in 10 mins, 15000 ms before msg disapears
xautolock \
    -locker 'slock -m  "$(cowsay $(fortune))"' \
    -notify 300 \
    -notifier "notify-send -u critical -t 15000 -- 'Locking screen in 10 minutes'" \
    -time 10 &
eval $(ssh-agent)

#########
# Audio #
#########

start-pulseaudio-x11 --start &
pavucontrol &

#############
# Autostart #
#############

barrierc --daemon --no-tray --restart --enable-crypto 192.168.1.120 &
#nm-tray &
#blueman-applet &
blueman-manager &
megasync &
flatpak run com.discordapp.Discord &

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
