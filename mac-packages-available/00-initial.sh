#!/bin/bash
source $3/functions.sh

_set_env(){

	if [ ! -e ~/.profile ]; then
		touch ~/.profile
	fi

	if [ ! -e /etc/launchd.conf ]; then
		touch /etc/launchd.conf
	fi

	echo alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app' >> ~/.profile
	echo alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app' >> ~/.profile
	#TODO copy ENV/Fonts ~/Library/Fonts
}

case "$1" in
install)
	_set_env
;;
remove)
;;
esac

