#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install -y apache2
    sudo ufw allow in "Apache Full"
;;
remove)
;;
esac
