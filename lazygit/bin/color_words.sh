#!/bin/sh

git diff --color-words --word-diff --no-index --color=always --no-ext-diff "$2" "$5"
