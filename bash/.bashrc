# .bashrc

# If not running interactively, don't do anything more
if [[ $- != *i* ]]; then 
    return
fi

# if remote x11
#if [[ $DISPLAY = "localhost:10.0" ]]; then
#    #setxkbmap -option caps:swapescape
#    #setxkbmap -option grp:lalt_lshift_toggle
#    #setxkbmap -layout us,gr

#    #xset r rate 250 50;
#fi

# starship prompt
eval "$(starship init bash)"
# IMPORTANT: starship goes before sensible.bash

# pyenv
eval "$(~/.pyenv/bin/pyenv init -)"

# source sensible bash
if [ -f ~/.local/bash/sensible.bash ]; then
    source ~/.local/bash/sensible.bash
fi

# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# fzf
if [ -d /usr/share/doc/fzf/ ]; then
    source /usr/share/doc/fzf/completion.bash
    source /usr/share/doc/fzf/key-bindings.bash
fi

# shellcheck source=./bin/aliases
source ~/bin/aliases

# shellcheck source=./bin/functions.bash
source ~/bin/functions.bash

# colors! wow!
#$(fd . ~/repos/Color-Scripts/color-scripts/ | grep -v pipe | shuf -n 1)
#~/repos/Color-Scripts/color-scripts/crunchbang-mini

# Exports
export BROWSER="vivaldi-stable"
export GOPATH=$HOME/go
export EDITOR="nvim"
# export LS_COLORS=$(dircolors)
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"

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

export LESS+="-R --mouse --wheel-lines=2"

# simulate a login shell and show everything that is done (except in areas where stderr is redirected with zsh) along with the name of the file currently being interpreted.
#PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2

