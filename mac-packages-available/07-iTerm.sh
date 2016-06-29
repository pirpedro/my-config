#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install iterm2
  __my_env CLICOLOR 1
	__my_env TERM xterm-256color
;;
remove)
;;
esac
