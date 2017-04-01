#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
  __brew_cask_install docker
  brew install homebrew/completions/docker-completion
  brew install homebrew/completions/docker-compose-completion
;;
remove)
;;
esac
