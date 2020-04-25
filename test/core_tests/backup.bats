#!/usr/bin/env bash

TEST_FOLDER="$(pwd)"
load "$TEST_FOLDER"/test_helper/helper.bash

MY_CONFIG_EXT="${TEST_FOLDER%%'/test'}"/ext
source $MY_CONFIG_EXT/functions.sh

assert_config_file(){
  assert [ "$1" == "$(my_config_get backup.$1.name)" ]
  assert [ "$2" == "$(my_config_get backup.$1.source)" ]
  assert [ "$3" == "$(my_config_get backup.$1.sourcetype)" ]
  assert [ "$4" == "$(my_config_get backup.$1.target)" ]
  assert [ "$5" == "$(my_config_get backup.$1.targettype)" ]
  empty "$6" || assert [ "$6" == "$(my_config_get backup.$1.rotate)" ]
}

src_folder=~/src
target_folder=~/target
test_file=$src_folder/testfile
test_folder=$src_folder/testfolder
test_folder_content=$test_folder/anothertestfile

function setup {
  my_init
  [ ! -d "${src_folder}" ] || rm -rf "${src_folder}"
  [ ! -d "${target_folder}" ] || rm -rf "${target_folder}"
  mkdir -p ${src_folder} ${target_folder} ${test_folder}
  touch ${test_file}  ${test_folder_content}
}

function teardown {
  [ ! -d "${src_folder}" ] || rm -rf "${src_folder}"
  [ ! -d "${target_folder}" ] || rm -rf "${target_folder}"
}

@test "backup new - without args" {
  run my backup new || assert_failure
  assert_output "No backup name informed."
}
#
# @test "backup new - one argument" {
#   run my backup new teste || assert_failure
#   assert_output "No source informed."
# }
#
# @test "backup new - two argument" {
#   run my backup new teste /usr/local/bin || assert_failure
#   assert_output "No target informed."
# }
#
# @test "backup new - source type doesn't exist" {
#   run my backup new teste "type:whatever@test" "${target_folder}" || assert_failure
#   assert_output "Source type not valid."
# }
#
# @test "backup new - target type doesn't exist" {
#   run my backup new teste "${src_folder}" "type:whatever@test"  || assert_failure
#   assert_output "Target type not valid."
# }
#
# @test "backup new - source location doesn't exist" {
#   run my backup new teste "/path/to/file" "${target_folder}"  || assert_failure
#   assert_output "Source is not a regular file or directory."
# }

# @test "backup new - valid source file location " {
#   run my backup new "teste" "${test_file}" "${target_folder}"  || assert_success
#   assert_config_file "teste" "${test_file}" "local" "${target_folder}" "local"
# }
#
# @test "backup new - valid source dir location " {
#   run my backup new teste "${test_folder}" "${target_folder}"  || assert_success
#   assert_config_file "teste" "${test_folder}" "local" "${target_folder}" "local"
# }

# @test "backup new - invalid types of sources and targets " {
#   local src target
#   src="test1"; target="test2"
#   run my backup new teste "gist:${src}" "rsync:${target}"  || assert_failure
#   assert_output "Source type not valid."
#   run my backup new teste "mysql:${src}" "postgres:${target}"  || assert_failure
#   assert_output "Target type not valid."
# }
#
# @test  "backup new - different types of sources and targets " {
#   local src target
#   src="test1"; target="test2"
#   run my backup new teste1 "mysql:${src}" "rsync:${target}"  || assert_success
#   assert_config_file "teste1" "${src}" "mysql" "${target}" "rsync "
#   run my backup new teste2 "${test_file}" "gist:${target}"  || assert_success
#   assert_config_file "teste2" "${test_file}" "local" "${target}" "gist"
# }
