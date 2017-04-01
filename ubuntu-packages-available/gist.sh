#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require ruby
case "$1" in
install)
    gem install gist
    gist --login
    my_sync ~/.gist
;;
remove)
;;
esac
