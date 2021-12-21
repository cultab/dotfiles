

autoload -Uz compinit
compinit
autoload -Uz edit-command-line;
zle -N edit-command-line

HISTFILE=~/.histfile
HISTSIZE=9999999999999999  # infinite!
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='(cd *|cd|ls  *|ls|q|bg *|bg|fg *|fg|history *|history|clear|exec zsh)'
setopt nomatch
bindkey -e

LS_COLORS=$(dircolors)

zstyle :compinstall filename '/home/evan/.zshrc'
zstyle ':completion:*' group-name ''
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
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^[[Z" reverse-menu-complete
bindkey "^X" edit-command-line
# delete now works
bindkey    "^[[3~"          delete-char
bindkey " " magic-space


# bindkey -M vicmd 'k' history-beginning-search-backward
# bindkey -M vicmd 'j' history-beginning-search-forward
# disable -r time       # disable shell reserved word alias time='time -p ' # -p for POSIX output
export TIMEFMT=$'real\t%*E\nuser\t%*U\nsys\t%*S'

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
