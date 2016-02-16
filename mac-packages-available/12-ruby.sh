#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew install rbenv ruby-build
	echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
	source ~/.bash_profile
	rbenv install 2.3.0
	gem install rails 4.2.5.1
;;
remove)
;;
esac