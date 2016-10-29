#!/bin/bash
source $3/functions.sh

__require homebrew rlang
case "$1" in
install)
	__brew_cask_install rstudio

;;
remove)
;;
esac
