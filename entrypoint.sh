#!/usr/bin/env bash
case "$1" in
  open) ${SHELL_IDE:-code} . ~/.myconfig              ;;
  ssh) vagrant up; vagrant ssh                        ;;
  test) test/run_core_tests.sh                        ;;
  test_all) test/run_all_tests.sh                     ;;
  *) echo "Project actions: [open | ssh | test | test_all]" ;;
esac
