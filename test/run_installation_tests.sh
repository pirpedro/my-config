#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1


tests=()
for i in ubuntu; do
  for file in ${1:-$(ls -p installation_tests/ | grep -v / | grep .bats)}; do
    tests+=( "installation_tests/$file" )
  done

  for file in ${1:-$(ls -p installation_tests/$i/ | grep -v / | grep .bats)}; do
    tests+=( "installation_tests/$i/$file" )
  done

  #####   TESTING MAKEFILE  ##################
  echo "TESTING MAKEFILE"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #download and use makefile to install
  vagrant ssh "$i" -c "git clone https://github.com/pirpedro/my-config; cd my-config; git checkout develop; git submodule update --init --recursive; sudo make install"
  #run tests
  vagrant ssh "$i" -c "cd my-config/test; bats core_tests/"

  #########   TESTING INSTALLATION SCRIPT (STABLE VERSION)   #############
  echo "TESTING INSTALLATION SCRIPT (STABLE VERSION)"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #use installer script to handle everything
  vagrant ssh "$i" -c "cp /vagrant/contrib/installer .; chmod +x installer; sudo ./installer install stable"
  #download repo again to run the tests
  vagrant ssh "$i" -c "git clone https://github.com/pirpedro/my-config; cd my-config; git checkout develop; git submodule update --init --recursive;"
  vagrant ssh "$i" -c "cd my-config/test; bats core_tests/"

  #########   TESTING INSTALLATION SCRIPT (DEVELOPMENT VERSION)   #############
  echo "TESTING INSTALLATION SCRIPT (DEVELOPMENT VERSION)"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #use installer script to handle everything
  vagrant ssh "$i" -c "cp /vagrant/contrib/installer .; chmod +x installer; sudo ./installer install develop"
  #download repo again to run the tests
  vagrant ssh "$i" -c "cd my-config/test; bats core_tests/"

  #vagrant destroy -f "$i" || true
  #vagrant up "$i" || true
  #vagrant ssh "$i" -c "cd /usr/local/my-config/test; bats ${tests[@]};"
  #vagrant halt -f "$i" || true
done
