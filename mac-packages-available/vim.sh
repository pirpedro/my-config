#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require homebrew git
case "$1" in
install)
  __brew_install vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  __my_sync ~/.vimrc
  vim +PluginInstall +qall
;;
remove)
;;
esac
