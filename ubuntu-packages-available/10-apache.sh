#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install apache2
;;
remove)
;;
esac