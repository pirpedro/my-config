#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install git git-core
    gem install gist
    gist --login
;;
remove)
;;
esac
