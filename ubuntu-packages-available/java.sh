#!/bin/bash

source $3/functions.sh

case "$1" in
install)

    sudo apt-get remove openjdk*

    #adding oracle java repository
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    #installing jre 1.8
    sudo apt-get install -y oracle-java8-installer

;;
remove)
;;
esac
