#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

#install chromedriver for selenium tests
my_require homebrew
case "$1" in
install)
    my_brew_install chromedriver
    #launching at startup
    ln -sfv /usr/local/opt/chromedriver/*.plist ~/Library/LaunchAgents


;;
remove)
;;
esac
