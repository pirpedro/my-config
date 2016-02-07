#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install sublime-text3
    ln -s ~/Applications/Sublime\ Text.app /Applications/
;;
remove)
;;
esac
