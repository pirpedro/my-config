#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    sudo apt-get install -y mysql-server mysql-client
    sudo mysql_install_db
    sudo /usr/bin/mysql_secure_installation

    #Verify MySQL status
    sudo service mysql status

;;
remove)
;;
esac
