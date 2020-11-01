# .bashrc

# add stuff to $PATH
if [[ -d ~/bin ]]; then
	PATH+=":$HOME/bin:./:$HOME/.local/share/applications:$HOME/go/bin:$HOME/.cargo/bin"
fi

# If not running interactively, don't do anything more
if [[ $- != *i* ]]; then 
    return
fi

if [[ $WSLENV ]]; then
	if [[ $(pwd) == "/mnt/c/Users/evan" ]]; then cd ~; fi
	if [ ! $TMUX ]; then exec tmux ; fi
fi

# colors
#msgcat  --color=test | head -10 | tail -8

# starship prompt
eval "$(starship init bash)"

# IMPORTAND: starship goes before sensible.bash

# source sensible bash
if [ -f ~/.local/bash/sensible.bash ]; then
   source ~/.local/bash/sensible.bash
fi

# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
fi

# pandoc completion
if [ -x "$(command -v pandoc)" ]; then
    eval "$(pandoc --bash-completion)"
fi

# colors! wow!
$(fd . ~/repos/Color-Scripts/color-scripts/ | grep -v pipe | shuf -n 1)

# Exports
export BROWSER="vivaldi-stable"
export GOPATH=$HOME/go
export EDITOR="vim"

export LS_COLORS=$(dircolors)

alias wtf="netbsd-wtf -o"

alias coomit="git commit"

alias vimdiff="vim -d"

alias cat="bat"

#alias ls="lsd --group-dirs=first"
#alias ll="lsd --group-dirs=first --long"
#alias la="lsd --group-dirs=first --long --almost-all"
#alias lt="lsd --group-dirs=first --tree"
alias ls="exa --group-directories-first"
alias ll="exa --group-directories-first --long"
alias la="exa --group-directories-first --long --all"
alias lt="exa --group-directories-first --tree"

alias grep="grep --color=auto"

alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

alias q="exit"

alias mpiall="mpirun --use-hwthread-cpus"
alias mpirf="mpirun --oversubscribe"

alias stress_mem="stress --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1"

alias pse="ps aux | grep"

#export FZF_DEFAULT_OPTS='--ansi '
#export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude '.git' --color=always'

xi () {
	if [ "$@" ]; then
		if [ "$1" = "-u" ]; then
			shift
		fi
		if [ $(command -v xbps-install) ]; then
			sudo xbps-install -Su "$@" || sudo xbps-install -uy xbps
		elif [ $(command -v apt) ]; then
			sudo apt install "$@"
		fi
		return
	fi
	if [ $(command -v xbps-install) ]; then
		xpkg -a |
			fzf -m --preview 'xbps-query -R {1}' --preview-window=right:66%:wrap |
			xargs -ro sudo xbps-install -Suy 
	elif [ $(command -v apt) ]; then
		apt-cache pkgnames --generate |
			fzf -m --preview 'apt-cache showpkg {1}' --preview-window=right:66%:wrap |
			xargs -ro sudo apt-get install -y 
	fi
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

# simulate a login shell and show everything that is done (except in areas where stderr is redirected with zsh) along with the name of the file currently being interpreted.
#PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2

nnnvim ()
{
	tmux split-window -h -p 85 nvim --listen /tmp/nnnvim;
	n
}
