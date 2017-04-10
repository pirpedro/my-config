#!/bin/bash

#Test functions inside ext/functions.sh file.

load $(pwd)/test_helper/helper.bash

MY_CONFIG_EXT=../ext
source ../ext/functions.sh

tmp_file="$HOME/$(random 16)"
old_profile=$PROFILE
old_alias=$ALIAS_FILE
old_path=$PATH_FILE

function setup(){
  PROFILE=$tmp_file
  [ -f "$tmp_file" ] || touch "$tmp_file"
  chmod +x $tmp_file
  PROFILE=$tmp_file
  ALIAS_FILE=$tmp_file
  PATH_FILE=$tmp_file
}

function teardown(){
  rm "$tmp_file"
  PROFILE=$old_profile
  ALIAS_FILE=$old_alias
  PATH_FILE=$old_path
}

@test "os check" {
  run __is_linux && assert_failure
  run __is_mac && assert_success
}

@test "my_env" {
  #testing variable export
  my_env TEST "/path/to/file/test"
  assert_equal "${TEST}" "/path/to/file/test"
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "export TEST=/path/to/file/test"
  assert_equal "$(launchctl getenv TEST)" "/path/to/file/test"
  #testing a simple line of code inclusion
  my_env "if [[ 0 == 0 ]]; then echo \"good\"; fi"
  run cat "$tmp_file"
  assert_equal "${lines[1]}" "if [[ 0 == 0 ]]; then echo \"good\"; fi"

  #testing if no arguments are passed.
  run my_env && assert_failure
}
