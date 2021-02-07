#!/bin/bash

xi () {
    if [ "$@" ]; then
        if [ "$1" = "-u" ]; then
            shift
        fi
        sudo xbps-install -Su "$@" || sudo xbps-install -uy xbps
        return
    fi
    xpkg -a |
        fzf -m --preview 'xbps-query -R {1}' --preview-window=right:66%:wrap |
        xargs -ro sudo xbps-install -Suy 
    }

xr () {
    if [ "$@" ]; then
        sudo xbps-remove -R "$@"
        return
    fi
    xpkg -m |
        fzf -m --preview 'xbps-query {1}' --preview-window=right:66%:wrap |
        xargs -ro sudo xbps-remove -Roy
    }

google () {
    if [[ -z $* ]]; then
        echo "google: missing query"
        return
    fi
    query=$(echo "https://www.startpage.com/rvd/search?query=$*" | sed -e 's/+/%2B/g' -e 's/ /+/g')
    $BROWSER "$query" 2> /dev/null &
    disown
}

search () {
    path="$1"
    shift
    if [[ ! -d "$path" ]]; then
        echo "Usage: search <path> <pattern>"
        return
    fi
    find "$path" -name "$@" 2> /dev/null
}

hist () {
    history |
        fzf --no-sort --tac |
        sed 's/  / /g' |
        cut --complement -d ' ' -f 1-4 |
        xclip -i
    }

mkcd () {
    mkdir "$1" && cd "$1"
}

rmd_template () {
    cp -r ~/Documents/template/* ./
}

# nnnvim ()
# {
#     tmux split-window -h -p 85 nvim --listen /tmp/nnnvim;
#     n
# }
