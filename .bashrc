# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

#PS1='[\u@\h \W]\$ '


complete -c sudo

export EDITOR="vim"

export VIMMAP="~/.config/nvim/mappings.vim"
export VIMPLUG="~/.config/nvim/pluggins.vim"
export VIMSET="~/.config/nvim/settings.vim"

blink="\[\e[5m\]";
bold="\[\e[1m\]";
o_br="\[\e[38;5;9m\][";
user="\[\e[38;5;11m\]\u";
at="\[\e[38;5;10m\]@";
host="\[\e[38;5;14m\]\H:";
dir="\[\e[38;5;13m\]\W";
c_br="\[\e[38;5;9m\]]";
doll="\[\e[38;5;7m\]\$ ";
reset="\[\e[m\]";

export PS1="$bold$o_br$user$at$host$dir$c_br$doll$reset"

alias xi="sudo xbps-install -Suv"
alias xr="sudo xbps-remove -Rv"
alias xro="sudo xbps-remove -ov"
alias xq="xbps-query"

alias :q="exit"
alias e="vim"

alias rm="rm -i"

alias mpiall="mpirun --use-hwthread-cpus"

alias search="find / -name"

#keymaps
setxkbmap -option caps:swapescape

