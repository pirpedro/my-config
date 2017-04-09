#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1

tests=()
for i in ubuntu; do
  for file in ${1:-$(ls -p core_tests/ | grep -v / | grep .bats)}; do
    tests+=( "core_tests/$file" )
    if [[ -d "core_tests/$i" && -e "core_tests/$i/$file" ]]; then
      tests+=( "core_tests/$i/$file" )
    fi
  done
  vagrant up "$i"
  command="cd /usr/local/my-config/test; bats ${tests[@]};"
  vagrant ssh "$i" -c "$command"
done
