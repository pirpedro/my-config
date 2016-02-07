#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install iterm2
	ln -s ~/Applications/iTerm.app /Applications/
;;
remove)
;;
esac