#!/bin/sh

# XDG
# export XDG_RUNTIME_DIR="/run/user/$(id -u)"
mkdir -p "$HOME/.cache/run"
export XDG_RUNTIME_DIR="$HOME"/.cache/run
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/home/evan/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-/home/evan/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-/home/evan/.local/share}"

if [ -f "/home/evan/.local/share/antidot/env.sh" ]; then
    . "/home/evan/.local/share/antidot/env.sh";
fi

if [ -f "/home/evan/.local/share/antidot/alias.sh" ]; then
    . "/home/evan/.local/share/antidot/alias.sh";
fi
# don't pollute my $HOME plz

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export LESSKEY="${XDG_CONFIG_HOME}/less/lesskey"
export npm_config_cache="${XDG_CACHE_HOME}/npm"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export ATOM_HOME="$XDG_DATA_HOME/atom"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export IPFS_PATH="$XDG_DATA_HOME/ipfs"

# keychain
eval "$(keychain --eval --quiet --dir "$XDG_RUNTIME_DIR/keychain")"

export _JAVA_AWT_WM_NONREPARENTING=1

# cowfile path for cowsay
export COWPATH="$COWPATH:$HOME/.local/share/cowsay"

PATH_EXTRA=""

PATH_add() {
    if [ -d "$1" ]; then
        # PATH_EXTRA="$1${PATH_EXTRA:+:${PATH_EXTRA}}"   # prepending
        PATH_EXTRA="${PATH_EXTRA:+${PATH_EXTRA}:}$1"   # appending
    # else
    #     printf "%s does not exist, not adding to \$PATH\n" "$1"
    fi
}

# add stuff to $PATH
PATH_add ~/bin
PATH_add ~/Appimages
PATH_add ./
PATH_add "$HOME/.local/share/applications"
PATH_add "$HOME/.local/bin"
PATH_add "$GOPATH/bin"
PATH_add "$CARGO_HOME/bin"
PATH_add "/opt/flutter/bin"
PATH_add "/opt/megasync/usr/bin"
# opt tools
PATH_add "/opt/haxe_20210701100239_1385eda"
PATH_add "/opt/neko-2.3.0-linux64"

export HADOOP_HOME="/opt/hadoop-3.1.0"
export SQOOP_HOME="/opt/sqoop-1.4.7.bin__hadoop-2.6.0"
export MONGODB_HOME="/opt/mongodb-linux-x86_64-rhel80-4.4.5"
export FLOOM_HOME="/opt/apache-flume-1.9.0-bin"
export KAFKA_HOME="/opt/kafka_2.13-2.7.0"

PATH_add "$HADOOP_HOME/bin"
PATH_add "$MONGODB_HOME/bin"
PATH_add "$FLOOM_HOME/bin"
PATH_add "$FLOOM_HOME/conf"
PATH_add "$KAFKA_HOME/bin"

PATH_add "$PYENV_ROOT/bin"

# CUDA
PATH_add "/usr/local/cuda/bin"

PATH_add "/opt/microchip/xc16/v2.00/bin"
PATH_add "$HOME/.local/share/neovim/bin"
PATH_add "$GOPATH/bin"
PATH_add "/opt/quarto/bin"
PATH_add "$HOME/.local/share/cargo/bin"
PATH_add "$HOME/.local/share/bob/nvim-bin"



PATH="$PATH_EXTRA${PATH:+:${PATH}}"   # prepending
export PATH

export XBPS_DISTDIR="$HOME/repos/void-packages"

# eval "$(pyenv init --path)"
if [ -f "home/evan/.local/share/cargo/env" ]; then
	. "/home/evan/.local/share/cargo/env"
fi

if [ -e /home/evan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/evan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
