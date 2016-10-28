#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	__brew_cask_install rstudio

;;
remove)
;;
esac
