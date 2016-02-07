#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install rstudio
	ln -s ~/Applications/RStudio.app /Applications/
;;
remove)
;;
esac