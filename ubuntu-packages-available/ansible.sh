#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
  sudo apt-get install software-properties-common
  sudo apt-add-repository ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install ansible
;;
remove)
;;
esac
