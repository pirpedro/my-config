#!/bin/bash

#Test functions inside ext/functions.sh file.

load "$(pwd)"/test_helper/helper.bash

MY_CONFIG_EXT=../ext
source ../ext/functions.sh

tmp_file="$HOME/$(random 16)"
old_profile=$PROFILE
old_alias=$ALIAS_FILE
old_path=$PATH_FILE
old_installed=$INSTALLED_FILE
old_configuration=$CONFIGURATION_FILE

function setup(){
  PROFILE=$tmp_file
  [ -f "$tmp_file" ] || touch "$tmp_file"
  chmod +x $tmp_file
  PROFILE=$tmp_file
  ALIAS_FILE=$tmp_file
  PATH_FILE=$tmp_file
  INSTALLED_FILE=$tmp_file
  CONFIGURATION_FILE=$tmp_file
}

function teardown(){
  rm "$tmp_file"
  PROFILE=$old_profile
  ALIAS_FILE=$old_alias
  PATH_FILE=$old_path
  INSTALLED_FILE=$old_installed
  CONFIGURATION_FILE=$old_configuration
}

@test "format_script_name" {
  run __format_script_name "/tmp/teste/myfile.sh"
  assert_output "myfile"

  run __format_script_name "/usr/local/bin/other-file"
  assert_output "other-file"

  run __format_script_name ""
  assert_failure
}

@test "load_config_file" {
  echo "test1=/path/to/file
test2=value" >> $tmp_file

  run __load_config_file && assert_failure "Test without file path"
  run __load_config_file "$tmp_file" && assert_success "Test with file path"
  #test variable retrival
  __load_config_file "$tmp_file"
  assert_equal "$test1" "/path/to/file"
  assert_equal "$test2" "value"
}

@test "exists" {
  run __exists cp && assert_success #real command
  run __exists rm && assert_success #real command
  run __exists fake && assert_failure #fake command
  run __exists && assert_failure #no argument
}

@test "my_alias - testing variable export" {
  #testing variable export
  my_alias testalias "echo \"worked\""
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "alias testalias='echo \"worked\"'"
}

@test "my_alias - testing if no arguments are passed." {
  run my_alias && assert_failure
}

@test "my_alias - testing if only one argument is passed." {
  run my_alias "al" && assert_failure
}

@test "my_path - remove from empty file" {
  local real_path=$PATH
  my_path_remove "/path/to/file"
  assert_equal "$PATH" "$real_path"
  run cat "$tmp_file"
  assert_output ""
}

@test "my_path - remove from PATH" {
  local real_path=$PATH
  echo "export PATH=/path/to/file:/other/path/to/file:/one/more/path:\$PATH" > $tmp_file
  export PATH=/path/to/file:/other/path/to/file:/one/more/path:$PATH
  my_path_remove "/other/path/to/file"
  assert_equal "$PATH" "/path/to/file:/one/more/path:$real_path"
  run cat "$tmp_file"
  assert_output="export PATH=/path/to/file:/one/more/path:\$PATH"
}

@test "my_path - remove last item from path" {
  local real_path=$PATH
  echo "export PATH=/path/to/file:\$PATH" > $tmp_file
  export PATH=/path/to/file:$PATH
  my_path_remove "/path/to/file"
  assert_equal "$PATH" "$real_path"
  run cat "$tmp_file"
  assert_output ""
}

@test "my_path - include first" {
  local real_path=$PATH
  my_path "/path/to/file"
  assert_equal "$PATH" "/path/to/file:$real_path"
  run cat "$tmp_file"
  assert_output "export PATH=/path/to/file:\$PATH"
}

@test "my_path - include more than one" {
  local real_path=$PATH
  my_path "/path/to/file"
  my_path "/other/path/to/file"
  assert_equal "$PATH" "/other/path/to/file:/path/to/file:$real_path"
  run cat "$tmp_file"
  assert_output "export PATH=/other/path/to/file:/path/to/file:\$PATH"
}

@test "my_path - replicate inclusion" {
  local real_path=$PATH
  my_path "/path/to/file"
  my_path "/path/to/file"
  assert_equal "$PATH" "/path/to/file:$real_path"
  run cat "$tmp_file"
  assert_output "export PATH=/path/to/file:\$PATH"
}

@test "__required - no arguments" {
  run __required && assert_failure
}

@test "__required - only one argument" {
  run __required install && assert_failure
}

@test "__required - include first element" {
  run __required install first
  assert_success
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "first"
}

@test "__required - include multiple elements" {
  run __required install first && assert_success
  run __required install second && assert_success
  run __required install third && assert_success
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "first"
  assert_equal "${lines[1]}" "second"
  assert_equal "${lines[2]}" "third"
}

@test "__required - include existent element" {
  __required install first
  __required install second
  __required install first
  __required install third
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "first"
  assert_equal "${lines[1]}" "second"
  assert_equal "${lines[2]}" "third"
}

@test "__required - check existence in empty file" {
  run __required check first && assert_failure
  run cat "$tmp_file"
  assert_output ""
}

@test "__required - check existence (true validation)" {
  __required install first
  __required install second
  __required install third
  run __required check second && assert_success
}

@test "__required - check existence (false validation)" {
  __required install first
  __required install second
  __required install third
  run __required check other && assert_failure
}

@test "__required - remove in empty file" {
  run __required remove first && assert_success
  run cat "$tmp_file"
  assert_output ""
}

@test "__required - remove only element" {
  __required install first
  run __required remove first && assert_success
  run cat "$tmp_file"
  assert_output ""
}

@test "__required - remove random element" {
  __required install first
  __required install second
  __required install third
  run __required remove second && assert_success
  run cat "$tmp_file"
  assert_equal "${lines[0]}" "first"
  assert_equal "${lines[1]}" "third"
}

@test "key/value configuration - insert/retrieve key" {
  run my_config_set "sync.folder" "/path/to/file" && assert_success
  run my_config_get "sync.folder" && assert_success
  assert_output "/path/to/file"
}

@test "key/value configuration - retrieve inexistent key" {
  run my_config_get "sync.folder" && assert_failure
}

@test "key/value configuration - retrieve all" {
  my_config_set "test.key1.path" "value1"
  my_config_set "test.key4.other" "value4"
  my_config_set "test.key2.path" "value2"
  my_config_set "test.key3.path" "value3"
  run my_config_get_regex "test.*.path"
  assert_equal "${lines[0]}" "test.key1.path value1"
  assert_equal "${lines[1]}" "test.key2.path value2"
  assert_equal "${lines[2]}" "test.key3.path value3"
}

@test "key/value configuration - unset value" {
  run my_config_set "sync.folder" "/path/to/file" && assert_success
  run my_config_get "sync.folder" && assert_success
  assert_output "/path/to/file"
  run my_config_unset "sync.folder" && assert_success
  assert_output ""
}

@test "key/value configuration - remove section" {
  run my_config_set "sync.folder" "/path/to/file" && assert_success
  run my_config_set "sync.file" "test_file" && assert_success
  run my_config_remove_section "sync" && assert_success
  run my_config_get "sync.file" && assert_failure
}
