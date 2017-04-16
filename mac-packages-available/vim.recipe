#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew git
case "$1" in
install)
  my_brew_install vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  my_sync ~/.vimrc
  vim +PluginInstall +qall
;;
remove)
;;
esac
