#!/bin/sh

fail() {
    printf "Fatal: %s" "$1"
    exit 1
}
URL='https://github.com/slavfox/Cozette/releases/download/v.1.23.1/CozetteFonts-v-1-23-1.zip'
FILE='CozetteFonts-v-1-23-1.zip'
cd /tmp || fail "failed to cd to /tmp"
wget "${URL}" 
mkdir -p "${XDG_DATA_HOME}/fonts"
unzip "${FILE}" -d "${XDG_DATA_HOME}/fonts/"
