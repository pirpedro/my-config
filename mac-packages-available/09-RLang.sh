#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew install r
    #enable rJava usage
    R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
;;
remove)
;;
esac