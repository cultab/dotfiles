#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/workbin:$PATH"

# If not running interactively, don't do anything more
if [[ $- != *i* ]]; then
	return
fi

if [[ -n "$CURSOR_AGENT" ]]; then
	return
fi

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
		source /usr/share/doc/fzf/examples/key-bindings.bash
	elif [ -d /usr/share/doc/fzf/examples/ ]; then
		source /usr/share/doc/fzf/key-bindings.bash
	fi
fi

# shellcheck source=./bin/aliases
source ~/bin/aliases

# shellcheck source=/bin/functions.sh
source ~/bin/functions.sh

# shellcheck source=./bin/exports
source ~/bin/exports

# simulate a login shell and show everything that is done (except in areas where stderr is redirected with zsh) along with the name of the file currently being interpreted.
#PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2

# automagically enter venvs
auto_sauce() {
	if [[ -z $VIRTUAL_ENV ]]; then
		if [[ -f .venv/bin/activate ]] then
			source .venv/bin/activate
		fi
	fi
}
# eval "$(~/.local/bin/agent shell-integration bash)"
# keep .bash_history always up to date
PROMPT_COMMAND="history -a; auto_sauce; $PROMPT_COMMAND"

if [[ -f ~/.internalrc ]]; then
	source ~/.internalrc
fi

if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

