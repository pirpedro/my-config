#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-add-repository ppa:teejee2008/ppa -y
  sudo apt-get update
  sudo apt-get install conky conky-manager -y

;;
remove)
;;
esac
