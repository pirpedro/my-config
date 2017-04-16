#!/usr/bin/env bash

load "$(pwd)"/test_helper/helper.bash

test_folder="$HOME/sync_test_folder"
first_folder="$test_folder/a_folder"
first_folder_file="$first_folder/file1"
second_folder="$test_folder/a_folder2"
second_folder_file="$second_folder/file1"
first_file="$test_folder/a_file.txt"
second_file="$test_folder/a_file2"
content_first="file1 has content."
content_second="file2 has content."


setup() {
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
  [ ! -d $test_folder ] || rm -rf $test_folder
  mkdir -p "$test_folder"
  mkdir -p "$first_folder"
  touch "$first_folder_file" && echo "$content_first" >> $first_folder_file
  mkdir -p "$second_folder"
  touch "$second_folder_file" && echo "$content_second" >> $second_folder_file
  touch "$first_file" && echo "$content_first" >> $first_file
  touch "$second_file" && echo "$content_second" >> $second_file
}

teardown() {
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
  [ ! -d $test_folder ] || rm -rf $test_folder
}

@test "sync alias - no arguments" {
  run my sync alias && assert_failure
  assert_output "No alias name passed."
}

@test "sync alias - set new alias" {
  run my sync alias "/path/to/something" "/path/to/anything" && assert_success
  assert_output ""
  run my sync alias "/path/to/something" && assert_success
  assert_output "/path/to/anything"
}

@test "sync alias - with glob expansion" {
  run my sync alias "~/path/to" "~/new/path/folder" && assert_success
  assert_output ""
  run my sync alias "~/path/to" && assert_success
  assert_output "~/new/path/folder"
}

@test "sync alias - retrieve not existent key." {
  run my sync alias "/path/to/something" && assert_failure
  assert_output "There isn't any alias named /path/to/something."
}

@test "sync alias - change key value" {
  run my sync alias "/path/to/something" "/path/to/anything" && assert_success
  assert_output ""
  run my sync alias "/path/to/something" "otherpath" && assert_success
  assert_output ""
  run my sync alias "/path/to/something"
  assert_output "otherpath"
}

@test "sync - no arguments" {
  run my sync && assert_failure
  assert_output --partial "usage"
}

@test "sync - only one argument" {
  run my sync "~/path/to/a/folder" && assert_failure
  assert_output "Fatal: Same location."
}

@test "sync - two argument (paths doesn't exist)" {
  run my sync "~/path/to/a/file" "/path/to/another/file" && assert_failure
  assert_output "Source and target paths doesn't exist."
}

@test "sync - file >> empty(symlink)" {
  run my sync "$first_file" "$test_folder/new_file" && assert_success && assert_output ""
  assert [ -L "$test_folder/new_file" ]
  run cat "$test_folder/new_file" && assert_output "$content_first"
}

@test "sync - file >> empty(copy)" {
  run my sync -c "$first_file" "$test_folder/new_file" && assert_success && assert_output ""
  assert [ ! -L "$test_folder/new_file" ]
  assert [ -f "$first_file" ]
  run cat "$test_folder/new_file" && assert_output "$content_first"
}

@test "sync - file >> file(symlink)" {
  run my sync "$first_file" "$second_file" && assert_failure
  assert_output "Target "$second_file" already exist. Use -f to force substitution."
  assert [ -f "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
  assert [ -f "$second_file" ]
  run cat "$second_file" && assert_output "$content_second"
}

@test "sync - file >> file(symlink) force" {
  run my sync -f "$first_file" "$second_file" && assert_success && assert_output ""
  assert [ -f "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
  assert [ -L "$second_file" ]
  run cat "$second_file" && assert_output "$content_first"
}

@test "sync - file >> file(copy)" {
  run my sync -c "$first_file" "$second_file" && assert_failure
  assert_output "Target "$second_file" already exist. Use -f to force substitution."
  assert [ -f "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
  assert [ -f "$second_file" ]
  run cat "$second_file" && assert_output "$content_second"
}

@test "sync - file >> file(copy) force" {
  run my sync -f -c "$first_file" "$second_file" && assert_success && assert_output ""
  assert [ -f "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
  assert [ ! -L "$second_file" ]
  run cat "$second_file" && assert_output "$content_first"
}

@test "sync - empty >> file(symlink)" {
  new_file="$test_folder/my_file"
  run my sync "$new_file" "$first_file" && assert_success && assert_output ""
  assert [ -f "$new_file" ]
  run cat "$new_file" && assert_output "$content_first"
  assert [ -L "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
}

@test "sync - empty >> file(copy)" {
  new_file="$test_folder/my_file"
  run my sync -c "$new_file" "$first_file" && assert_success && assert_output ""
  assert [ -f "$new_file" ]
  run cat "$new_file" && assert_output "$content_first"
  assert [ ! -L "$first_file" ]
  run cat "$first_file" && assert_output "$content_first"
}

#folder

@test "sync - folder >> empty(symlink)" {
  run my sync "$first_folder" "$test_folder/new_folder" && assert_success && assert_output ""
  assert [ -L "$test_folder/new_folder" ]
  run cat "$test_folder/new_folder/file1" && assert_output "$content_first"
}

@test "sync - folder >> empty(copy)" {
  run my sync -c "$first_folder" "$test_folder/new_folder" && assert_success && assert_output ""
  assert [ -d "$test_folder/new_folder" ]
  assert [ -f "$test_folder/new_folder/file1" ]
  run cat "$test_folder/new_folder/file1" && assert_output "$content_first"
}

@test "sync - folder >> folder(symlink)" {
  run my sync "$first_folder" "$second_folder" && assert_failure
  assert_output "Target "$second_folder" already exist. Use -f to force substitution."
  assert [ -d "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
  assert [ -d "$second_folder" ]
  run cat "$second_folder_file" && assert_output "$content_second"
}

@test "sync - folder >> folder(symlink) force" {
  run my sync -f "$first_folder" "$second_folder" && assert_success && assert_output ""
  assert [ -d "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
  assert [ -L "$second_folder" ]
  run cat "$second_folder_file" && assert_output "$content_first"
}

@test "sync - folder >> folder(copy)" {
  run my sync -c "$first_folder" "$second_folder" && assert_failure
  assert_output "Target "$second_folder" already exist. Use -f to force substitution."
  assert [ -d "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
  assert [ -d "$second_folder" ]
  run cat "$second_folder_file" && assert_output "$content_second"
}

@test "sync - folder >> folder(copy) force" {
  run my sync -f -c "$first_folder" "$second_folder" && assert_success && assert_output ""
  assert [ -d "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
  assert [ -d "$second_folder" ]
  run cat "$second_folder_file" && assert_output "$content_first"
}

@test "sync - empty >> folder(symlink)" {
  new_folder="$test_folder/my_folder"
  run my sync "$new_folder" "$first_folder" && assert_success && assert_output ""
  assert [ -d "$new_folder" ]
  run cat "$new_folder/file1" && assert_output "$content_first"
  assert [ -L "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
}

@test "sync - empty >> folder(copy)" {
  new_folder="$test_folder/my_folder"
  run my sync -c "$new_folder" "$first_folder" && assert_success && assert_output ""
  assert [ -d "$new_folder" ]
  run cat "$new_folder/file1" && assert_output "$content_first"
  assert [ -d "$first_folder" ]
  run cat "$first_folder_file" && assert_output "$content_first"
}
