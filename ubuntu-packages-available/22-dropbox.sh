#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
  sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
  sudo apt-get update && sudo apt-get install -y nautilus-dropbox
;;
remove)
sudo apt-get remove nautilus-dropbox
;;
rc)
  echo $(dirname $0)/rc/dropbox-sync
  sudo ln -s $(dirname $0)/../rc/dropbox-sync /etc/init.d/dropbox-sync
  sudo chmod +x /etc/init.d/drobox-sync
  sudo ln -s /etc//init.d/dropbox-sync K03DropboxSync

;;
esac
