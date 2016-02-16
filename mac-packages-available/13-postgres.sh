#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew install postgres
	ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
;;
remove)
;;
esac