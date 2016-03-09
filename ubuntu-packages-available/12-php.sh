#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install php5 php5-mysql libapache2-mod-php5 php5-mcrypt php5-curl php5-xmlrpc

;;
remove)
;;
esac