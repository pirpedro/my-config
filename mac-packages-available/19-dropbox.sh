#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  __brew_cask_install dropbox
  __brew_cask_install wget
  __brew_install pygtk
  wget -O /usr/local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"
;;
remove)
;;
rc)
;;
esac
