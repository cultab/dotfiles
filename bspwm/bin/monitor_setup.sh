#!/bin/sh

setup="$1"
MONITOR=$(xrandr | grep ' connected' | cut -d ' ' -f1)
echo "$MONITOR"


# 1 monitor only
if [ "$(echo "$MONITOR" | wc -l)" = "1" ]; then
    setup="single"
fi


case "$setup" in
    single)
        bspc monitor "$MONITOR" --reset-desktops I II III IV V VI
        bspc monitor "$MONITOR" --swap '^1'
        xrandr --output "$MONITOR" --primary
        ;;
    thinkpad_vga)
        xrandr --output VGA1 --primary --auto
        xrandr --output VGA1 --left-of LVDS1

        bspc wm --reorder-monitors 'VGA1 LVDS1'
        bspc monitor VGA1 --reset-desktops I II III IV V VI
        bspc monitor VGA1 --swap '^1'
        ;;
    at_work)
        xrandr --output DP-1-8 --primary
        xrandr --output DP-1-1 --left-of DP-1-8
        xrandr --output eDP-1 --right-of DP-1-8

        bspc wm --reorder-monitors 'DP-1-1 DP-1-8 eDP-1'
        # bspc monitor DP-1-1 --reset-desktops
        # bspc monitor eDP-1 --reset-desktops
        bspc monitor DP-1-8 --reset-desktops I II III IV V VI
        bspc monitor DP-1-8 --swap '^1'
        ;;
    *)
        printf "No such setup: %s\n" "$setup"
        echo "Maybe you have more than one monitor attached?"
        ;;
esac

