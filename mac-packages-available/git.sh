#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require homebrew
case "$1" in
install)
  git status
  __brew_install gnupg
  __brew_install gnupg2
  __my_env GPG_TTY "\$(tty)"
  __my_sync ~/.gitconfig
  __my_sync ~/.git

  #create man and documentations
  __brew_install pandoc
;;
remove)
;;
esac
