# .bashrc

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then 
    return
fi

#if running in a graphical env, run tmux
#if [[ $DISPLAY ]]; then
#    [[ -z "$TMUX" ]] && exec tmux new-session
#fi

if [[ -z "$TMUX" ]] ;then
    ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        exec tmux new-session
    else
        exec tmux attach-session -t "$ID" # if available attach to it
    fi
fi

#PS1='[\u@\h \W]\$ '

# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

#set -o vi


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

alias wtf="netbsd-wtf -o"

alias xi="doas xbps-install -Su"
alias xr="doas xbps-remove -R"
alias xs="xbps-query -Rs"
alias xq="xbps-query"

alias ls="exa --group-directories-first"
alias ll="exa -l --group-directories-first"
alias la="exa -la --group-directories-first"
alias lt="exa --tree --group-directories-first"

alias diff="diff --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias vimdiff="vim -d"
alias e="vim"

alias cp="cp -iv"
alias rm="echo -e '# Consider using trash-cli #\n'; rm -iv"
alias mv="mv -iv"

alias q="exit"

alias mpiall="mpirun --use-hwthread-cpus"
alias mpirf="mpirun --oversubscribe"

search () {
    find / -name $1 2> /dev/null
}

#keymaps cause .xinirc is not enough..
setxkbmap -option caps:swapescape

export EDITOR="vim"
export VISUAL="emacs"
export MYVIMRC=~/.config/nvim/init.vim

# man colors ?
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

eval "$(starship init bash)"
