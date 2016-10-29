#!/bin/bash
source $3/functions.sh

__require homebrew
case "$1" in
install)
	__brew_cask_install dbeaver-enterprise
;;
remove)
;;
esac
