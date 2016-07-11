#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew install rbenv ruby-build
  __my_env "if which rbenv > /dev/null; then eval \"\$(rbenv init -)\"; fi"
    brew install openssl
    brew link openssl --force
	rbenv install 2.3.0
  rbenv global 2.3.0
  echo "gem: --no-document" > ~/.gemrc
  gem install bundler
	gem install rails 4.2.5.1
  gem install pry
  rbenv rehash
;;
remove)
;;
esac
