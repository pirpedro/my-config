#!/bin/bash
source $2/functions.sh

setEnvMac(){
	if [ $(exists launchctl) == "1" ]; then
		echo foca
	fi
	
	if [ ! -e ~/.profile ]; then
		touch ~/.profile
	fi

	if [ ! -e /etc/launchd.conf ]; then
		touch /etc/launchd.conf
	fi
	
	echo alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app' >> ~/.profile
	echo alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app' >> ~/.profile
}

case "$1" in
install)
	if [ $(isMac) == "1" ]; then
		setEnvMac
	else
		echo foca
	fi

	
;;
remove)
;;
esac
