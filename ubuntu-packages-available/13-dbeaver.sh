#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    #install gdebi, a package installer for debian based linux
    sudo apt-get install gdebi
    wget http://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb
    sudo gdebi dbeaver-ce_3.6.1_amd64.deb

;;
remove)
;;
esac