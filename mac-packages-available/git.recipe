#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
  git status
  my_brew_install gnupg
  my_brew_install gnupg2
  my_env GPG_TTY "\$(tty)"
  my_sync ~/.gitconfig
  my_sync ~/.git

  #create man and documentations
  my_brew_install pandoc
;;
remove)
;;
esac
