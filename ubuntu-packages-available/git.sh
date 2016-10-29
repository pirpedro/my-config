#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    sudo apt-get install -y git git-core
    __my_sync ~/.gitconfig
    __my_sync ~/.git

;;
remove)
;;
esac
