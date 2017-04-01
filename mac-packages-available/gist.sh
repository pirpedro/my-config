#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
  my_brew_install gist
  gist --login
  my_sync ~/.gist
;;
remove)
;;
esac
