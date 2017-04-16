#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require git
case "$1" in
install)
  sudo apt-get install curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  my_env "PATH" "\$HOME/.rbenv/bin:\$PATH"
  my_env "if which rbenv > /dev/null; then eval \"\$(rbenv init -)\"; fi"

  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  git clone -- https://github.com/carsomyr/rbenv-bundler.git ~/.rbenv/plugins/bundler
  my_env "PATH" "\$HOME/.rbenv/plugins/ruby-build/bin:\$PATH"

  rbenv install 2.3.0
  rbenv global 2.3.0
  echo "gem: --no-document" > ~/.gemrc
  gem install bundler
  gem install rails 4.2.5.1
  gem install pry
  rbenv rehash

   # A few Rails features, such as the Asset Pipeline, depend on a Javascript runtime. Remember to install Node.js to provide this functionality.


;;
remove)
;;
esac
