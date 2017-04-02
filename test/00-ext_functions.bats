#!/bin/bash

#Test functions inside ext/functions.sh file.

load test_helper/helper

MY_CONFIG_EXT=../ext
source ../ext/functions.sh

@test "format_script_name" {
  run __format_script_name "/tmp/teste/myfile.sh"
  assert_output "myfile"

  run __format_script_name "/usr/local/bin/other-file"
  assert_output "other-file"

  run __format_script_name ""
  assert_failure
}

@test "load_config_file" {
  local file="test.conf"
  [ ! -f "$file" ] || touch "$file"
  echo "test1=/path/to/file
test2=value" >> $file

  run __load_config_file && assert_failure "Test without file path"
  run __load_config_file "$file" && assert_success "Test with file path"
  #test variable retrival
  __load_config_file "$file"
  assert_equal "$test1" "/path/to/file"
  assert_equal "$test2" "value"
  rm "$file"
}

@test "exists" {
  run __exists cp && assert_success #real command
  run __exists rm && assert_success #real command
  run __exists fake && assert_failure #fake command
  run __exists && assert_failure #no argument
}

@test "my_alias" {
  local file="test_bash.sh"
  local old_alias=$ALIAS_FILE
  [ -f "$file" ] || touch "$file"
  ALIAS_FILE="$file"
  #testing variable export
  my_alias testalias "echo \"worked\""
  run cat "$file"
  assert_equal "${lines[0]}" "alias testalias='echo \"worked\"'"

  #testing if no arguments are passed.
  run my_alias && assert_failure

  #testing if only one argument is passed.
  run my_alias "al" && assert_failure
  #removing test files
  rm "$file"
  ALIAS_FILE=$old_alias
}
