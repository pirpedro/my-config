#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require java
case "$1" in
install)
    #install gdebi, a package installer for debian based linux
    sudo apt-get install -y gdebi
    wget http://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb
    sudo gdebi dbeaver-ce_latest_amd64.deb

;;
remove)
;;
esac
