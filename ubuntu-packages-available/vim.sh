#!/bin/bash
source $3/functions.sh

__require git
case "$1" in
install)
  sudo apt-get install -y vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  __my_sync ~/.vimrc

  #install exuberant-ctags
  sudo apt-get install -y exuberant-ctags

  vim +PluginInstall +qall

;;
remove)
;;
esac
q
