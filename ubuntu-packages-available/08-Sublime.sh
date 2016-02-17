#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew cask install sublime-text3
    ln -s ~/Applications/Sublime\ Text.app /Applications/
    #install sublime package manager
    wget -P ~/.config/sublime-text-3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

    #TODO link dropbox installed packages

;;
remove)
;;
esac
