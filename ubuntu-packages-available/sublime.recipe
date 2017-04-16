#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get install -y sublime-text-installer
    wget -P ~/.config/sublime-text-3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

    my_sync /applications/sublime/config/Packages/User ~/.config/sublime-text-3/Packages/
;;
remove)
;;
esac
