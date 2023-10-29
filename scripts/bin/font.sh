#!/usr/bin/env bash
#
export help="Usage: $0 [-pts] [-h] [-d]

-p --previewer <command> \t\t what to run in spawned terminal
-t --terminal <command> \t\t which terminal to spawn (add argument to accept font)
-s --switch_back <command> \t\t how to switch to last window (the one running this script)
-h --help \t show this and quit
-d --defaults \t show defaults and quit
"

############
# DEFAULTS #
############

# command used to show some text
PREVIEW_COMMAND="bat new.lua"
# command to spawn terminal, assumes terminal will interpret arguments after -- as program to run
TERMINAL_COMMAND="st -f"
# command to go to last window (the one running this)
SWITCH_BACK_COMMAND="bspc node -f last"

size=16

while [ "$@" ]; do
    case $1 in
        --previewer|-p)
            shift
            PREVIEW_COMMAND=$1
            ;;
        --terminal|-t)
            shift
            TERMINAL_COMMAND=$1
            ;;
        --switch_back|-s)
            shift
            SWITCH_BACK_COMMAND=$1
            ;;
        --help|-h)
            printf "%b\n" "$help"
            exit 0
            ;;
        --defaults|-d)
            printf "%s\n%s\n%s\n" \
            'PREVIEW_COMMAND="bat"' \
            'TERMINAL_COMMAND="st -f"' \
            'SWITCH_BACK_COMMAND="bspc node -f last"'
            exit 0
            ;;
    esac
    shift

done

readarray -t fonts < <(fc-list : family | sort | grep -E '[Mm]ono|Nerd Font' | cut -f 1 -d ',' | uniq)

idx=0

while true; do
    echo "Font[${idx}]: ${fonts[$idx]} size: ${size}"

    # terminal spawn command \/
    $TERMINAL_COMMAND "${fonts[$idx]}:size=${size}" -- sh -c "$PREVIEW_COMMAND; sleep 50" & # preview command
    pid=$!
    sleep 0.2           # timeout for terminal to spawn
    $SWITCH_BACK_COMMAND

    escape_char=$(printf "\u1b")
    read -rsn1 mode # get 1 character
    if [[ $mode == "$escape_char" ]]; then
        read -rsn2 mode # read 2 more chars
    fi

    case $mode in
        'q') echo QUITTING ; kill "$pid"; exit ;;
        '[A') size=$((size+1)) ;;
        '[B') size=$((size-1)) ;;
        '[D') idx=$((idx-1)) ;;
        '[C') idx=$((idx+1)) ;;
        *) >&2 echo 'ERR bad input'; ;;
    esac

    if [ "$pid" ]; then
        kill "$pid"
    fi
done
