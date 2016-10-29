#!/bin/bash
source $3/functions.sh

__require homebrew
case "$1" in
install)
  __brew_install gist
  gist --login
  __my_sync ~/.gist
;;
remove)
;;
esac
