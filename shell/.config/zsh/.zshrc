#!/usr/bin/zsh
autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
autoload -Uz edit-command-line;
zle -N edit-command-line

zmodload zsh/zpty
# zmodload zsh/zprof
export HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
mkdir -p $(dirname "$HISTFILE")
HISTORY_IGNORE='(cd|ls *|ls|q|bg|fg|history *|history|clear|exec zsh|gs)'

setopt INTERACTIVE_COMMENTS      # Use '#' for comments, even in interactive mode
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS       # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

typeset -gA FAST_BLIST_PATTERNS; FAST_BLIST_PATTERNS[/mnt/*]=1 # don't autocomplete files in path
setopt nomatch
setopt extendedglob
setopt globdots # complete (dot).files
bindkey -e

LS_COLORS=$(dircolors)

zstyle :compinstall filename '/home/evan/.zshrc'
zstyle ':completion:*' group-name ''
# zstyle ':autocomplete:*' groups 'always'
zstyle ':completion:*' format '%F{blue}[%d]%f'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete _correct _extensions
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}[%d err: %e]%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# "ss" [UP ARROW] -> "ssh -p22 some.domain.xyz"
# incremental search
bindkey "\e[A"  history-beginning-search-backward
bindkey "\e[B"  history-beginning-search-forward
bindkey "^P"    history-beginning-search-backward
bindkey "^N"    history-beginning-search-forward
bindkey "^[[Z"  reverse-menu-complete
bindkey "^X"    edit-command-line
# delete now works
bindkey "^[[3~" delete-char
bindkey " "     magic-space

# bindkey -M vicmd 'k' history-beginning-search-backward
# bindkey -M vicmd 'j' history-beginning-search-forward
# disable -r time       # disable shell reserved word alias time='time -p ' # -p for POSIX output
export TIMEFMT=$'real\t%*E\nuser\t%*U\nsys\t%*S'

setopt noclobber                 # Don't overwrite existing file when redirecting output

# conditional source
# if file exists source it
csource() {
    if [[ -f "$1" ]]; then
        source "$1"
    else
        echo "Didn't source: $1"
        echo "As it is missing."
    fi
}

# csource ~/.config/zsh/transient_starship_prompt
# eval "$(starship init zsh)"
OHMYPOSH_THEME='emodipt-extend'
# OHMYPOSH_THEME='bubbles'
# OHMYPOSH_THEME='star'
# OHMYPOSH_THEME='the-unnamed'
#  "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/${OHMYPOSH_THEME}.omp.json"
# eval "$(oh-my-posh init zsh --config "~/.config/ohmyposh/themes/emodipt-extend.omp.json")"
# eval $(thefuck --alias)

csource ~/bin/exports
csource ~/bin/aliases
csource ~/bin/functions.sh


if [[ ! -f "$HOME/.local/share/miniplug.zsh" ]]; then
    curl \
        -sL --create-dirs \
        https://git.sr.ht/~yerinalexey/miniplug/blob/master/miniplug.zsh \
        -o $HOME/.local/share/miniplug.zsh
fi

fpath=(~/.local/share/zsh/complete ~/.local/share/miniplug/spwhitt/nix-zsh-completions ~/.local/share/miniplug/sindresorhus/pure/ $fpath)

source "$HOME/.local/share/miniplug.zsh"

# miniplug plugin 'zsh-users/zsh-syntax-highlighting'
# miniplug plugin 'spaceship-prompt/spaceship-prompt'
# miniplug plugin 'se-jaeger/zsh-activate-py-environment'
miniplug plugin 'spwhitt/nix-zsh-completions'
miniplug plugin 'zsh-users/zsh-autosuggestions'
miniplug plugin 'zpm-zsh/colorize'
miniplug plugin 'zdharma-continuum/fast-syntax-highlighting'
miniplug plugin 'sindresorhus/pure'
miniplug load

autoload -U promptinit; promptinit
prompt pure

fast-theme --quiet XDG:overlay

csource "$HOME/.local/zsh/wezterm.sh"

autoload -U compinit && compinit
prompt_nix_shell_setup "$@"

if [[ "$WSL_DISTRO_NAME" && ! $(pgrep wezterm_reload) ]]; then
	(wezterm_reload &)
#     pkill -9 oneterm_reload; oneterm_reload & disown
fi

if command nitch 2>&1 > /dev/null; then
	nitch
fi


# zprof
