#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-get install -y vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
  __my_sync ~/.vimrc
;;
remove)
;;
esac
