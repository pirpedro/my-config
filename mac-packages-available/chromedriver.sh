#!/bin/bash
source $3/functions.sh

#install chromedriver for selenium tests
__require homebrew
case "$1" in
install)
    __brew_install chromedriver
    #launching at startup
    ln -sfv /usr/local/opt/chromedriver/*.plist ~/Library/LaunchAgents


;;
remove)
;;
esac