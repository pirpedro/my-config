#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
  __brew_cask_install dropbox
  __brew_cask_install wget
  my_brew_install pygtk
  wget -O /usr/local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"
;;
remove)
;;
extra)
;;
esac
