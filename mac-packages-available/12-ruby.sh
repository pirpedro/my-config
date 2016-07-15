#!/bin/bash
source $3/functions.sh

case "$1" in
install)
	brew install rbenv ruby-build ruby-bundler
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

  # A few Rails features, such as the Asset Pipeline, depend on a Javascript runtime. We will install Node.js to provide this functionality.
  sudo add-apt-repository ppa:chris-lea/node.js
  sudo apt-get update
  sudo apt-get install nodejs
;;
remove)
;;
esac
