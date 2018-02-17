#!/bin/bash

# Load a library from the `${BATS_TEST_DIRNAME}/test_helper' directory.
#
# Globals:
#   none
# Arguments:
#   $1 - name of library to load
# Returns:
#   0 - on success
#   1 - otherwise
load_lib() {
  local name="$1"
  load "$(pwd)/test_helper/${name}/load.bash"
}

load_lib bats-support
load_lib bats-assert

my_init(){
  [ ! -d ~/.myconfig ] || rm -rf ~/.myconfig
  printf '\n' | run my config init
  assert_success
}
