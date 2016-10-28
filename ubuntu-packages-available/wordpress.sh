#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install php5-gd
    wget http://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    mysql -u root -p


    #TODO https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-12-04

;;
remove)
;;
esac