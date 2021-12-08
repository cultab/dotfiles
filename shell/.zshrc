
autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=9999999999999999  # infinite!
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='(cd *|cd|ls  *|ls|q|bg *|bg|fg *|fg|history *|history|clear)'
setopt nomatch
bindkey -e

LS_COLORS=$(dircolors)

zstyle :compinstall filename '/home/evan/.zshrc'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _extensions _complete _approximate 
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# "ss" [UP ARROW] -> "ssh -p22 some.domain.xyz"
# incremental search
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward

bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward
# disable -r time       # disable shell reserved word
# alias time='time -p ' # -p for POSIX output
export TIMEFMT=$'real\t%*E\nuser\t%*U\nsys\t%*S'

# delete now works
bindkey    "^[[3~"          delete-char

bindkey " " magic-space

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS       # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt noclobber                 # Don't overwrite existing file when redirecting output

eval "$(starship init zsh)"
eval $(thefuck --alias)

source ~/bin/exports
source ~/bin/aliases
source ~/bin/functions.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
