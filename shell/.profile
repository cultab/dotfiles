#!/bin/sh

# keychain
eval $(keychain --eval)

# export PROFILE_SOURCED=1
export _JAVA_AWT_WM_NONREPARENTING=1
# for pipewire, so that elogind is not needed
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# cowfile path for cowsay
COWPATH="$COWPATH:$HOME/.cowsay"

# add stuff to $PATH
if [ -d ~/bin ]
then
    PATH="$HOME/bin:$PATH"
fi

PATH="./:$PATH"

PATH="$HOME/.local/share/applications/:$PATH"
PATH="$HOME/.local/bin:$PATH"

PATH="$HOME/go/bin/:$PATH"

PATH="$HOME/.cargo/bin/:$PATH"

PATH="/opt/flutter/bin/:$PATH"

PATH="/opt/megasync/usr/bin/:$PATH"

# haxe
PATH="/opt/haxe_20210701100239_1385eda/:$PATH"
PATH="/opt/neko-2.3.0-linux64/:$PATH"

export HADOOP_HOME="/opt/hadoop-3.1.0"
export SQOOP_HOME="/opt/sqoop-1.4.7.bin__hadoop-2.6.0"
export MONGODB_HOME="/opt/mongodb-linux-x86_64-rhel80-4.4.5"
export FLOOM_HOME="/opt/apache-flume-1.9.0-bin"
export KAFKA_HOME="/opt/kafka_2.13-2.7.0"

PATH="$HADOOP_HOME/bin/:$PATH"
PATH="$MONGODB_HOME/bin/:$PATH"
PATH="$FLOOM_HOME/bin/:$PATH"
PATH="$FLOOM_HOME/conf/:$PATH"
PATH="$KAFKA_HOME/bin/:$PATH"

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/evan/.local/share/flatpak/exports/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"

export PYENVROOT="$HOME/.pyenv"
PATH="$PYENVROOT/bin:$PATH"

# CUDA
PATH="/usr/local/cuda-11.5/bin:$PATH"

export PATH

export XBPS_DISTDIR="$HOME/repos/void-packages"
