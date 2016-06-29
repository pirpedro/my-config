#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get install sublime-text-installer
    wget -P ~/.config/sublime-text-3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

    #TODO link dropbox installed packages
    #ln -s ~/Dropbox/Env/default/applications/sublime/config/Packages/User ~/.config/sublime-text-3/Packages/

;;
remove)
;;
esac
