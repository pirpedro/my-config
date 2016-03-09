#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install php5-gd
    wget http://wordpress.org/latest.tar.gz

;;
remove)
;;
esac