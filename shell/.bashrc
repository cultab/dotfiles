#!/bin/bash

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
	if [ -d /usr/share/doc/fzf/examples/ ]; then
		source /usr/share/doc/fzf/examples/completion.bash
		source /usr/share/doc/fzf/examples/key-bindings.bash
	else
		source /usr/share/doc/fzf/completion.bash
		source /usr/share/doc/fzf/key-bindings.bash
	fi
fi

# shellcheck source=./bin/aliases
source ~/bin/aliases

# shellcheck source=/bin/functions.sh
source ~/bin/functions.sh

# colors! wow!
#$(fd . ~/repos/Color-Scripts/color-scripts/ | grep -v pipe | shuf -n 1)
#~/repos/Color-Scripts/color-scripts/crunchbang-mini

# shellcheck source=./bin/exports
source ~/bin/exports

# simulate a login shell and show everything that is done (except in areas where stderr is redirected with zsh) along with the name of the file currently being interpreted.
#PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2

alias luamake=/home/evan/repos/lua-language-server/3rd/luamake/luamake

alias nix="NP_LOCATION=/home/evan/repos/vimconf_talk NP_RUNTIME='bwrap' /home/evan/repos/vimconf_talk/nix-portable nix"
