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

root_dir=$(my --exec-path)

my_init(){
  [ ! -f "$root_dir/installed" ] || rm "$root_dir/installed"
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
  printf '\n\n' | run my config init
  assert_success
}
