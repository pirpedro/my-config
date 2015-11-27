#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	if [ $(exists brew) ]; then
		brew install fish
		echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
		sudo -u $SUDO_USER chsh -s /usr/local/bin/fish
	else
		echo "Need HomeBrew Installation"
	fi

;;
remove)
;;
esac
