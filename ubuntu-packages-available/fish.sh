#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	apt-add-repository ppa:fish-shell/release-2
  apt-get update
	apt-get install fish
	sudo -u $SUDO_USER chsh -s /usr/bin/fish

;;
remove)
;;
esac
