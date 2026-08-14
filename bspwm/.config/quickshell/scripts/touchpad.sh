#!/bin/sh
# Prints the touchpad's enabled state as 1 or 0, toggling it first when passed
# "toggle". Exits non-zero with no output if no touchpad is present.

id=$(xinput list 2>/dev/null |
    grep -iEo 'touchpad[[:space:]]*id=[0-9]+' |
    grep -Eo '[0-9]+$' |
    head -n1)

[ -n "$id" ] || exit 1

enabled=$(xinput list-props "$id" 2>/dev/null | awk '/Device Enabled/ { print $NF }')

if [ "$1" = toggle ]; then
    if [ "$enabled" = 1 ]; then
        xinput disable "$id" && enabled=0
    else
        xinput enable "$id" && enabled=1
    fi
fi

printf '%s\n' "$enabled"
