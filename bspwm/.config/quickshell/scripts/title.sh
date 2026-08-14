#!/bin/sh
# Prints the active window's title, once per change, until killed.
# bspwm has no title in its report, so this tracks the EWMH properties directly.

active_id() {
    xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | grep -o '0x[0-9a-f]\{2,\}' | head -n1
}

get_title() {
    title=$(xprop -id "$1" _NET_WM_NAME 2>/dev/null |
        sed -n 's/^_NET_WM_NAME(UTF8_STRING) = "\(.*\)"$/\1/p')

    [ -n "$title" ] || title=$(xprop -id "$1" WM_NAME 2>/dev/null |
        sed -n 's/^WM_NAME([A-Z8_]*) = "\(.*\)"$/\1/p')

    printf '%s' "$title"
}

kill_tree() {
    [ -n "$1" ] || return 0
    for child in $(pgrep -P "$1" 2>/dev/null); do
        kill_tree "$child"
    done
    kill "$1" 2>/dev/null
}

# Titles change while a window stays focused (browser tabs), so each focused
# window gets its own watcher that is replaced on the next focus change. Both
# name properties are watched and usually change together, hence the dedupe.
# Quickshell SIGKILLs us on reload, which no trap can catch, so the watcher also
# gives up once the main script is gone instead of spying on forever.
watch_title() {
    last=$(get_title "$1")
    printf '%s\n' "$last"

    xprop -id "$1" -spy _NET_WM_NAME WM_NAME 2>/dev/null | while read -r _; do
        kill -0 "$main" 2>/dev/null || exit 0

        current=$(get_title "$1")
        [ "$current" = "$last" ] && continue
        last=$current
        printf '%s\n' "$current"
    done
}

# The focus watcher writes to a fifo rather than a pipe so that the reader loop
# stays in this shell, letting the exit trap reap both xprop processes. Without
# it they survive us and pile up every time the bar restarts.
main=$$
rundir=$(mktemp -d)
fifo=$rundir/focus
mkfifo "$fifo"

trap 'kill_tree "$watcher"; kill_tree "$spy"; rm -rf "$rundir"' EXIT HUP INT TERM

xprop -root -spy _NET_ACTIVE_WINDOW > "$fifo" 2>/dev/null &
spy=$!

while read -r _; do
    kill_tree "$watcher"
    watcher=""

    id=$(active_id)
    if [ -z "$id" ] || [ "$id" = "0x0" ]; then
        printf '\n'
        continue
    fi

    watch_title "$id" &
    watcher=$!
done < "$fifo"
