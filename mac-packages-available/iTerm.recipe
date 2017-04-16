#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
	__brew_cask_install iterm2
  my_env CLICOLOR 1
	my_env TERM xterm-256color
;;
remove)
;;
esac
