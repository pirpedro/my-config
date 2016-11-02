#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

__require homebrew
case "$1" in
install)
	__brew_install postgres
	ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
;;
remove)
;;
esac
