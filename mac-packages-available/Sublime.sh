#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	__brew_cask_install sublime-text-dev
  #install sublime package manager
  wget -P ~/Library/Application Support/Sublime Text 3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package

  __my_sync /applications/sublime/config/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/

;; 
remove)
;;
esac
