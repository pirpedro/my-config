#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
	__brew_cask_install sublime-text-dev
  #install sublime package manager
  wget -P ~/Library/Application Support/Sublime Text 3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

  my_sync /applications/sublime/config/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/

;; 
remove)
;;
esac
