#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
  sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
  sudo apt-get update && sudo apt-get install nautilus-dropbox
  wget -O ~/bin/dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py"
  chmod +x ~/bin/dropbox.py
;;
remove)
;;
rc)
;;
esac
