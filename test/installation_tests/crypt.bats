#!/usr/bin/env bash

load $(pwd)/test_helper/helper.bash

@test "crypt - install veracrypt" {
  run my crypt install veracrypt && assert_success
}

@test "crypt - install encfs" {
  run my crypt install encfs && assert_success
}

@test "crypt - try to reinstall veracrypt" {
  run my crypt install veracrypt && assert_failure
}

@test "crypt - try to reinstall encfs" {
  run my crypt install encfs && assert_failure
}

@test "crypt - remove veracrypt" {
  run my crypt remove veracrypt && assert_success
}

@test "crypt - remove encfs" {
  run my crypt remove encfs && assert_success
}

@test "crypt - try to remove veracrypt again" {
  run my crypt remove veracrypt && assert_failure
}

@test "crypt - try to remove encfs again" {
  run my crypt remove encfs && assert_failure
}
