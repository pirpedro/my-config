#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    sudo apt-get install -y calibre
;;
remove)
;;
esac
