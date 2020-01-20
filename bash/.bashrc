# .bashrc

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then 
    return
fi

if [[ -d ~/bin ]]; then
	PATH+="$HOME/bin"
fi

if [ -f ~/bin/sensible.bash ]; then
   source ~/bin/sensible.bash
fi

# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
fi

if [[ "$DISPLAY" ]] ;then
	if [[ -z "$TMUX" ]] ;then
		ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)" # get the id of a deattached session
		if [[ -z "$ID" ]] ;then                            # if not available create a new one
			exec tmux new-session
		else
			exec tmux attach-session -t "$ID"              # if available attach to it
		fi
	fi
fi

alias wtf="netbsd-wtf -o"

alias xi="doas xbps-install -Su"
alias xr="doas xbps-remove -R"
alias xs="xbps-query -Rs"
alias xq="xbps-query"

alias ls="lsd --group-dirs=first"
alias ll="lsd --group-dirs=first --long"
alias la="lsd --group-dirs=first --long --all"
alias lt="lsd --group-dirs=first --tree"

alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias svim='vim -u ~/projects/SpaceVim/vimrc'
alias vimdiff="vim -d"
alias e="vim"
alias micro="micro -matchbraceleft true -keepautoindent true -colorcolumn 80 -scrollbar true"

alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

alias q="exit"

alias mpiall="mpirun --use-hwthread-cpus"
alias mpirf="mpirun --oversubscribe"

search () {
	path="$1"
	shift
	if [[ ! -d "$path" ]]; then
		echo "Usage: search <path> <pattern>"
		return
	fi
    find "$path" -name "$@" 2> /dev/null
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
    export VISUAL="tmux split-window -h vim"
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

    # reset VISUAL
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

# starship prompt
eval "$(starship init bash)"

#these where a mistake
#they broke autocmpl
#complete -c sudo
#complete -c doas

#PROMPT_COMMAND='(retval=$?;tput cup "$LINES";exit $retval)'

#blink="\[\e[5m\]";
#bold="\[\e[1m\]";
#o_br="\[\e[38;5;9m\][";
#user="\[\e[38;5;11m\]\u";
#at="\[\e[38;5;10m\]@";
#host="\[\e[38;5;14m\]\H:";
#dir="\[\e[38;5;13m\]\W";
#c_br="\[\e[38;5;9m\]]";
#doll="\[\e[38;5;7m\]\$ ";
#reset="\[\e[m\]";
##reset_cursor='\033]50;CursorShape=1\x7'
#
#export PS1="$bold$o_br$user$at$host$dir$c_br$doll$reset"
