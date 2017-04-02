#!/bin/bash

#Test functions inside ext/functions.sh file.

load $(pwd)/test_helper/helper.bash

MY_CONFIG_EXT=../ext
source ../ext/functions.sh

@test "os check" {
  run __is_linux
  assert_success
  run __is_mac
  assert_failure
}

@test "my_env" {
  local file="test_bash.sh"
  local old_profile=$PROFILE
  [ -f "$file"] || touch "$file"
  PROFILE="$file"
  #testing variable export
  my_env TEST "/path/to/file/test"
  assert_equal "${TEST}" "/path/to/file/test"
  run cat "$file"
  assert_equal "${lines[0]}" "export TEST=/path/to/file/test"
  #testing a simple line of code inclusion
  my_env "if [[ 0 == 0 ]]; then echo \"good\"; fi"
  run cat "$file"
  assert_equal "${lines[1]}" "if [[ 0 == 0 ]]; then echo \"good\"; fi"

  #testing if no arguments are passed.
  run my_env && assert_failure

  rm "$file"
  PROFILE=$old_profile
}
