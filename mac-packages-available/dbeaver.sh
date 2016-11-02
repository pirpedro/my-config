#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require homebrew
case "$1" in
install)
	__brew_cask_install dbeaver-enterprise
;;
remove)
;;
esac
