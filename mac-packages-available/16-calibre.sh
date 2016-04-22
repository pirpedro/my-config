#!/bin/bash

source $3/functions.sh

case "$1" in
install)

    brew cask install calibre
    ln -s ~/Applications/calibre.app /Applications/

;;
remove)
;;
esac