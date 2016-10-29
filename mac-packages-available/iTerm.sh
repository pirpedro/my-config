#!/bin/bash
source $3/functions.sh

__require homebrew
case "$1" in
install)
	__brew_cask_install iterm2
  __my_env CLICOLOR 1
	__my_env TERM xterm-256color
;;
remove)
;;
esac
