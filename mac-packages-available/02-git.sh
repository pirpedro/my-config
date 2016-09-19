#!/bin/bash

source $3/functions.sh

case "$1" in
install)
  git status
  __brew_install gnupg
  __brew_install gnupg2
  __my_env GPG_TTY "\$(tty)"
;;
remove)
;;
esac
