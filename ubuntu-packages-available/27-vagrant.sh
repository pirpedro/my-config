#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-get install virtualbox vagrant virtualbox-dkms -y
;;
remove)
;;
esac
