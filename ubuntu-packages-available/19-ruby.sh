#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  __my_env "PATH" "\$HOME/.rbenv/bin:\$PATH"
  __my_env "if which rbenv > /dev/null; then eval \"\$(rbenv init -)\"; fi"

  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  git clone -- https://github.com/carsomyr/rbenv-bundler.git ~/.rbenv/plugins/bundler
  __my_env "PATH" "\$HOME/.rbenv/plugins/ruby-build/bin:\$PATH"

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
