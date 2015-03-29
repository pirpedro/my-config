#!/bin/bash
source $2/functions.sh

case "$1" in
install)
	if [ $(isMac) == "1" ]; then 
		if [ $(exists brew) ]; then
			brew install fish
			echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
			sudo -u $SUDO_USER chsh -s /usr/local/bin/fish
		else
			echo "Need HomeBrew Installation"
		fi	
	     		
	else
		apt-add-repository ppa:fish-shell/release-2
                apt-get update
		apt-get install fish
		sudo -u $SUDO_USER chsh -s /usr/bin/fish
	fi
;;
remove)
;;
esac
