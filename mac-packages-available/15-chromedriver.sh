#!/bin/bash
source $3/functions.sh

#install chromedriver for selenium tests

case "$1" in
install)
    brew install chromedriver
    #launching at startup
    ln -sfv /usr/local/opt/chromedriver/*.plist ~/Library/LaunchAgents


;;
remove)
;;
esac
