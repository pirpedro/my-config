#!/bin/bash
source functions.sh

setEnvMac(){
	if [ $(exists launchctl) == "1" ]; then
	fi

}

case "$1" in
install)
	if [ $(isMac) == "1" ]; then
		setEnvMac
	else

	fi

	
;;
remove)
;;
esac
