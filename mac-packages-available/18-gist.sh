#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  __brew_install gist
  gist --login
  __my_sync ~/.gist
;;
remove)
;;
esac
