#!/bin/sh

google () {
    if [ -z $* ]; then
        echo "google: missing query"
        return
    fi
    query=$(echo "https://www.startpage.com/rvd/search?query=$*" | sed -e 's/+/%2B/g' -e 's/ /+/g')
    $BROWSER "$query" 2> /dev/null &
    # disown
}

search () {
    path="$1"
    shift
    if [ ! -d "$path" ]; then
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
        xclip -i -selection clipboard
    }

mkcd () {
    mkdir "$1" && cd "$1" || exit
}

project () {
    mkdir "$1"
    echo "Created project folder $1.."
    cp -r ~/Documents/template/* "./$1"
    echo "Copied template files.."
    cd "$1" || exit
    echo "cd'ed into $1"
    git init
    echo "Initialized git repo"
    git add -- *
    echo "Added already existing files to repo"
    git commit -m 'project init'
    echo "Commited initial files to project repo"
}

rmd_template () {
    project "$@"
}

pse () {
    procs=$(ps -aux)
    header=$(echo "$procs" | head -1)
    search=$(echo "$procs" | grep --color=always "$@")
    # | grep -v 'grep'
    if [ -n "$search" ]; then
        printf '%s\n%s' "$header" "$search"
    fi
}

enable_more_completions () {
    # pandoc
    if [ -x "$(command -v pandoc)" ]; then
        eval "$(pandoc --bash-completion)"
    fi
    # flutter
    if [ -x "$(command -v flutter)" ]; then
        eval "$(flutter bash-completion)"
    fi
    # pipenv
    if [ -x "$(command -v pipenv)" ]; then
        eval "$(pipenv --completion)"
    fi

}

conda_enable () {
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/evan/.local/share/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/evan/.local/share/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/evan/.local/share/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/evan/.local/share/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

pyenv_enable () {
    # pyenv
    eval "$(~/.pyenv/bin/pyenv init -)"
}

lel() {
    echo hehe
    espeak -v el χεχε & # disown
}

# nnnvim ()
# {
#     tmux split-window -h -p 85 nvim --listen /tmp/nnnvim;
#     n
# }