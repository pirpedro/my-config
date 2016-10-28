#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install -y php libapache2-mod-php php-mcrypt php-mysql

;;
remove)
;;
esac
