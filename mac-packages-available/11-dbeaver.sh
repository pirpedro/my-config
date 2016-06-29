#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install dbeaver-enterprise

;;
remove)
;;
esac