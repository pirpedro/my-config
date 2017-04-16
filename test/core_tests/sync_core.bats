#!/usr/bin/env bash

TEST_FOLDER="$(pwd)"
load "$TEST_FOLDER"/test_helper/helper.bash

MY_CONFIG_EXT="${TEST_FOLDER%%'/test'}"/ext
source $MY_CONFIG_EXT/plugins/my-sync.helper

test_folder="$HOME/sync_test_folder"
setup() {
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
  [ ! -d $test_folder ] || rm -rf $test_folder
  mkdir -p "$test_folder"
}

teardown() {
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
  [ ! -d $test_folder ] || rm -rf $test_folder
}

@test "[sync core] __is_dir" {
  run __is_dir "$test_folder/fake_dir" && assert_failure
  touch "$test_folder/tmpfile"
  run __is_dir "$test_folder/tmpfile" && assert_failure
  ln -s "$test_folder/tmpfile" "$test_folder/tmpfile2"
  run __is_dir "$test_folder/tmpfile2" && assert_failure
  mkdir "$test_folder/mydir"
  run __is_dir "$test_folder/mydir" && assert_success
}

@test "[sync core] __is_regular_file" {
  run __is_regular_file "$test_folder/fake_dir" && assert_failure
  touch "$test_folder/tmpfile"
  run __is_regular_file "$test_folder/tmpfile" && assert_success
  ln -s "$test_folder/tmpfile" "$test_folder/tmpfile2"
  run __is_regular_file "$test_folder/tmpfile2" && assert_failure
  mkdir "$test_folder/mydir"
  run __is_regular_file "$test_folder/mydir" && assert_failure
}

@test "[sync core] __is_link" {
  run __is_link "$test_folder/fake_dir" && assert_failure
  touch "$test_folder/tmpfile"
  run __is_link "$test_folder/tmpfile" && assert_failure
  ln -s "$test_folder/tmpfile" "$test_folder/tmpfile2"
  run __is_link "$test_folder/tmpfile2" && assert_success
  mkdir "$test_folder/mydir"
  run __is_link "$test_folder/mydir" && assert_failure
}

@test "[sync core] __exist_path" {
  run __exist_path "$test_folder/fake_dir" && assert_failure
  touch "$test_folder/tmpfile"
  run __exist_path "$test_folder/tmpfile" && assert_success
  ln -s "$test_folder/tmpfile" "$test_folder/tmpfile2"
  run __exist_path "$test_folder/tmpfile2" && assert_success
  mkdir "$test_folder/mydir"
  run __exist_path "$test_folder/mydir" && assert_success
}

@test "[sync core] __substitute_alias - no alias" {
  run __substitute_alias "/path/to/file" && assert_success
  assert_output "/path/to/file"
  run __substitute_alias "path/to/file/" && assert_success
  assert_output "path/to/file/"
}

@test "[sync core] __substitute_alias - without backslash" {
  run my sync alias "john" "doe"
  run __substitute_alias "/path/john/folder" && assert_success
  assert_output "/path/doe/folder"
  run __substitute_alias "path/to/file/" && assert_success
  assert_output "path/to/file/"
}

@test "[sync core] __substitute_alias - with backslash" {
  run my sync alias "/home/john" "/folder"
  run __substitute_alias "/home/john/path/to/folder" && assert_success
  assert_output "/folder/path/to/folder"
  run __substitute_alias "path/to/file/" && assert_success
  assert_output "path/to/file/"
}

@test "[sync core] __substitute_alias - expand glob" {
  run my sync alias ~/test "/doe"
  run __substitute_alias "$HOME/test/folder" && assert_success
  assert_output "/doe/folder"
  run __substitute_alias "path/to/file/" && assert_success
  assert_output "path/to/file/"
}

@test "[sync core] __toogle - regular file" {
  touch "$test_folder/new_file" && echo "new_file_content" >> "$test_folder/new_file"
  mkdir "$test_folder/new_folder"
  run __toogle "$test_folder/new_folder/my_file" "$test_folder/new_file" && assert_success
  assert [ -f "$test_folder/new_folder/my_file" ]
  assert [ ! -f "$test_folder/new_file" ]
  run cat "$test_folder/new_folder/my_file" && assert_output "new_file_content"
}

@test "[sync core] __toogle - symbolic link" {
  touch "$test_folder/new_file" && echo "new_file_content" >> "$test_folder/new_file"
  mkdir "$test_folder/new_folder"
  ln -s "$test_folder/new_file" "$test_folder/sym_file"

  run __toogle "$test_folder/new_folder/my_file" "$test_folder/sym_file" && assert_failure
  assert [ ! -f "$test_folder/new_folder/my_file" ]
  assert [ -e "$test_folder/sym_file" ]
}

@test "[sync core] __toogle - folder" {
  mkdir "$test_folder/new_folder"
  touch "$test_folder/new_folder/new_file" && echo "new_file_content" >> "$test_folder/new_folder/new_file"
  run __toogle "$test_folder/newer_folder" "$test_folder/new_folder" && assert_success
  assert [ -f "$test_folder/newer_folder/new_file" ]
  assert [ ! -d "$test_folder/new_folder" ]
  run cat "$test_folder/newer_folder/new_file" && assert_output "new_file_content"
}

@test "[sync core] __is_tracking" {
  local source target type target2
  source="/path/to/folder"; target="/path/to/folder2"; type="sync"; target2="/other/path"
  run __track $source $target $type && assert_success && assert_output ""
  run __is_tracking "$source" "$target" && assert_success && assert_output ""
  run __is_tracking "$source" "$target2" && assert_failure && assert_output ""
  run __is_tracking "/wrong/source" "$target" && assert_failure && assert_output ""
}

@test "[sync core] __include_target" {
  local source target type target2
  source="/path/to/folder"; target="/path/to/folder2"; type="sync"; target2="/other/path"
  run __include_target "$source" "$target" && assert_success
  assert_equal "$target" "$(my_config_get sync.link-$source.target)"
  run __include_target "$source" "$target2" && assert_success
  assert_equal "$target $target2" "$(my_config_get sync.link-$source.target)"
  run __include_target "$source" "/more/target" && assert_success
  assert_equal "$target $target2 /more/target" "$(my_config_get sync.link-$source.target)"
}

@test "[sync core] __is_tracked_source" {
  local source target type target2
  source="/path/to/folder"; target="/path/to/folder2"; type="sync"; target2="/other/path"
  run __is_tracked_source "$source" && assert_failure
  run __track $source $target $type && assert_success
  run __is_tracked_source "$source" && assert_success
  run __is_tracked_source "/anything/else" && assert_failure
}

@test "[sync core] __track" {
  local source target type target2
  source="/path/to/folder"; target="/path/to/folder2"; type="sync"; target2="/other/path"
  run __track $source $target $type && assert_success
  assert_equal "$source" "$(my_config_get sync.link-$source.source)"
  assert_equal "$target" "$(my_config_get sync.link-$source.target)"
  assert_equal "$type" "$(my_config_get sync.link-$source.type)"

  run __track $source $target $type && assert_failure
  assert_equal "$source" "$(my_config_get sync.link-$source.source)"
  assert_equal "$target" "$(my_config_get sync.link-$source.target)"
  assert_equal "$type" "$(my_config_get sync.link-$source.type)"

  run __track $source $target2 $type && assert_success
  assert_equal "$source" "$(my_config_get sync.link-$source.source)"
  assert_equal "$target $target2" "$(my_config_get sync.link-$source.target)"
  assert_equal "$type" "$(my_config_get sync.link-$source.type)"
}
