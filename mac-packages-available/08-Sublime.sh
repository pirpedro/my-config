#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install sublime-text3
    #install sublime package manager
    wget -P ~/Library/Application Support/Sublime Text 3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

    #TODO link dropbox installed packages

;;
remove)
;;
esac
