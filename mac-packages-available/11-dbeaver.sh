#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install dbeaver-enterprise
	ln -s ~/Applications/Dbeaver.app /Applications/
;;
remove)
;;
esac