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

  vagrant destroy -f "$i" || true
  vagrant up "$i" || true
  vagrant ssh "$i" -c "cd /usr/local/my-config/test; bats ${tests[@]};"
  vagrant halt -f "$i" || true
done
