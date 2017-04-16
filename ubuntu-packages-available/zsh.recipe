#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require git
case "$1" in
install)
  sudo apt-get install -y zsh
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  zsh -c 'setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done'
  chsh -s /bin/zsh
;;
remove)
;;
update)
  git pull ${ZDOTDIR:-$HOME}/.zprezto && git submodule update --init --recursive ${ZDOTDIR:-$HOME}/.zprezto
;;
esac
