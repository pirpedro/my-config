#!/usr/bin/env bash
case "$1" in
  open) atom . ~/.myconfig           ;;
  test) test/run_core_tests.sh      ;;
  test_all) test/run_all_tests.sh   ;;
  *) echo "Project actions: [open | test | test_all]" ;;
esac
