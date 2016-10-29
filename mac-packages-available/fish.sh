#!/bin/bash
source $3/functions.sh

__require homebrew
case "$1" in
install)
	__brew_install fish
	echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
	sudo -u $SUDO_USER chsh -s /usr/local/bin/fish

;;
remove)
;;
esac
