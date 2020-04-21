# .bashrc

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then 
    return
fi

# add stuff to $PATH
if [[ -d ~/bin ]]; then
	PATH+=":$HOME/bin:./:$HOME/.local/share/applications"
fi

# starship prompt
eval "$(starship init bash)"

# IMPORTAND: starship goes before sensible.bash

# source sensible bash
if [ -f ~/.local/bash/sensible.bash ]; then
   source ~/.local/bash/sensible.bash
fi

# simulate a login shell and show everything that is done (except in areas where stderr is redirected with zsh) along with the name of the file currently being interpreted.
#PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2

# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
fi

# pandoc completion
eval "$(pandoc --bash-completion)"

start_tmux() {
    [[ $DISPLAY ]] && [[ -z "$TMUX" ]] && exec tmux
}

start_tmux

alias wtf="netbsd-wtf -o"

alias coomit="git commit"

alias vimdiff="vim -d"

alias cat="bat"

alias ls="lsd --group-dirs=first"
alias ll="lsd --group-dirs=first --long"
alias la="lsd --group-dirs=first --long --almost-all"
alias lt="lsd --group-dirs=first --tree"

alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

alias q="exit"

alias mpiall="mpirun --use-hwthread-cpus"
alias mpirf="mpirun --oversubscribe"

alias stress_mem="stress-ng --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1"

#export FZF_DEFAULT_OPTS='--ansi '
#export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude '.git' --color=always'

xi () {
	if [ "$@" ]; then
		if [ "$1" = "-u" ]; then
			shift
		fi
		sudo xbps-install -Su "$@" || sudo xbps-install -uy xbps
		return
	fi
	xpkg -a |
        fzf -m --preview 'xq -Rs {1}' \
            --preview-window=right:66%:wrap |
        xargs -ro sudo xbps-install -Suy 
}

xr () {
	if [ "$@" ]; then
		sudo xbps-remove -R "$@"
		return
	fi
    xpkg -m |
        fzf -m --preview 'xq {1}' \
            --preview-window=right:66%:wrap |
		xargs -ro sudo xbps-remove -Ry
}

google () {
	if [[ -z $* ]]; then
		echo "google: missing query"
		return
	fi
	query=$(echo "https://www.startpage.com/rvd/search?query=$*" | sed -e 's/+/%2B/g' -e 's/ /+/g')
	vivaldi-snapshot "$query" 2> /dev/null &
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
	xargs bash -c
}

mkcd () {
    mkdir "$1" && cd "$1"
}

nnnvim ()
{
	tmux split-window -h -p 85 nvim --listen /tmp/nnnvim;
	n
}

export NNN_CONTEXT_COLORS="2136"     # use a different color for each context
export NNN_TRASH=1                   # trash (needs trash-cli) instead of delete
export NNN_USE_EDITOR=1              # use the $EDITOR when opening text files

# stolen from https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash
n ()
{
    # Block nesting of nnn in subshells
    if [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # backup VISUAL and set it so as to open vim in a new tmux pane
    VISUAL_BAK=$VISUAL
    export VISUAL="nnnvim_handle"
    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # use -E for detached editing
    nnn -E "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi

    unset VISUAL
    export VISUAL=$VISUAL_BAK
}

export MYVIMRC=~/.config/nvim/init.vim

export EDITOR="vim"

export LS_COLORS=$(dircolors)

# man colors
export LESS_TERMCAP_mb=$(tput bold; tput setaf 3)            # begin bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 4)            # begin blink
export LESS_TERMCAP_me=$(tput sgr0)                          # reset bold/blink
export LESS_TERMCAP_so=$(tput rev; tput bold; tput setaf 3)  # begin reverse video
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)               # reset reverse video
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2) # begin underline
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)               # reset underline
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
