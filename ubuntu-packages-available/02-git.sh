#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    sudo apt-get install -y git git-core
;;
remove)
;;
esac
