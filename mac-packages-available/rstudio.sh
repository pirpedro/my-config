#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require homebrew rlang
case "$1" in
install)
	__brew_cask_install rstudio

;;
remove)
;;
esac
