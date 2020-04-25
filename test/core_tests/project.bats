#!/usr/bin/env bash

TEST_FOLDER="$(pwd)"
load "$TEST_FOLDER"/test_helper/helper.bash

MY_CONFIG_EXT="${TEST_FOLDER%%'/test'}"/ext
source $MY_CONFIG_EXT/functions.sh

proj_folder=~/projs
proj_test="projtest"
proj_test_location=${proj_folder}/${proj_test}
proj_test_sub="projsub"
proj_test_sub_location=${proj_folder}/subdir/${proj_test_sub}

assert_config_file(){
  assert [ "$1" == "$(my_config_get project.$1.name)" ]
  empty "$2" || assert [ "$2" == "$(my_config_get project.$1.path)" ]
  empty "$3" || assert [ "$3" == "$(my_config_get project.$1.git)" ]
}

function setup {
  my_init

  [ ! -d "${proj_folder}" ] || rm -rf "${proj_folder}"
  mkdir -p ${proj_test_location} ${proj_test_sub_location} ${proj_test_git_location}
}

function teardown {
  [ ! -d "${proj_folder}" ] || rm -rf "${proj_folder}"
}

@test "project - track not a valid path" {
  local path=/path/to/folder
  run my project track "${path}" || assert_failure
  assert_output "$path is not a valid directory."
}

@test "project - track current folder" {
  cd ${proj_test_location}
  run my project track || assert_success
  assert_output -p "Project ${proj_test} is now tracked."
  assert_config_file ${proj_test} ${proj_test_location}
}

@test "project - track other location" {
  run my project track ${proj_test_sub_location} || assert_success
  assert_output -p "Project ${proj_test_sub} is now tracked."
  assert_config_file ${proj_test_sub} ${proj_test_sub_location}
}

@test "project - track with another name" {
  local name="new_name"
  run my project track ${proj_test_location} ${name} || assert_success
  assert_output -p "Project ${name} is now tracked."
  assert_config_file ${name} ${proj_test_location}
}

@test "project - try to track again" {
  my project track ${proj_test_location}
  run my project track ${proj_test_location} || assert_failure
  assert_output -p "Project $proj_test is already tracked."
  assert_config_file ${proj_test} ${proj_test_location}
}

@test "project - track and run an existent entrypoint script" {
  echo "#!/bin/bash
  case \"\$1\" in
    install) echo \"Script running.\" ;;
  esac
  " > ${proj_test_location}/entrypoint.sh
  chmod +x ${proj_test_location}/entrypoint.sh
  run my project track ${proj_test_location} || assert_success
  assert_config_file ${proj_test} ${proj_test_location}
  assert_line -n 0 "Script running."
  assert_line -n 1 -p "Project ${proj_test} is now tracked."
}

@test "project - try to load a nonexistent project" {
  local fake_proj="fake_name"
  run my project ${fake_proj} || assert_failure
  assert_output "Not a valid command or project."
}

@test "project - load a project and run an existent entrypoint script" {
  my project track ${proj_test_location}
  run my project ${proj_test} || assert_success
  assert_output "Project loaded."
}

@test "project - load a project and test if directory was changed" {
  my project track ${proj_test_location}
  my project ${proj_test}
  assert_equal "$(pwd)" "${proj_test_location}"
}

@test "project - load a project with invalid location" {
  my project track ${proj_test_location}
  rm -rf ${proj_test_location}
  run my project ${proj_test} || assert_failure
  assert_output "Project $proj_test folder doesn't exist."
}

@test "project - exec some commands" {
    echo "#!/bin/bash
    case \"\$1\" in
      remove) echo \"Script removed.\" ;;
      testing) echo \"Script tested.\" ;;
    esac
    " > ${proj_test_location}/entrypoint.sh
    chmod +x ${proj_test_location}/entrypoint.sh
    my project track ${proj_test_location}
    run my project ${proj_test} exec remove || assert_success
    assert_output "Script removed."
    run my project ${proj_test} exec testing || assert_success
    assert_output "Script tested."
    run my project ${proj_test} exec nothing || assert_success
    assert_output ""

}

@test "project - exec some commands from project folder" {
    echo "#!/bin/bash
    case \"\$1\" in
      remove) echo \"Script removed.\" ;;
      testing) echo \"Script tested.\" ;;
    esac
    " > ${proj_test_location}/entrypoint.sh
    chmod +x ${proj_test_location}/entrypoint.sh
    my project track ${proj_test_location}
    my project ${proj_test}
    run my project exec remove || assert_success
    assert_output "Script removed."
    run my project exec testing || assert_success
    assert_output "Script tested."
    run my project exec nothing || assert_success
    assert_output ""
}

@test "project - untrack an invalid project" {
  local fake_proj="fake_name"
  run my project ${fake_proj} untrack || assert_failure
  assert_output "Not a valid command or project."
}

@test "project - untrack" {
  my project track ${proj_test_location}
  run my project ${proj_test} untrack || assert_success
  assert_output -p "Project ${proj_test} is not tracked anymore."
}

@test "project - untrack and run an existent entrypoint script" {
  echo "#!/bin/bash
  case \"\$1\" in
    remove) echo \"Script removed.\" ;;
  esac
  " > ${proj_test_location}/entrypoint.sh
  chmod +x ${proj_test_location}/entrypoint.sh
  my project track ${proj_test_location}
  run my project ${proj_test} untrack || assert_success
  assert_line -n 0 -p "Script removed."
  assert_line -n 1 -p "Project ${proj_test} is not tracked anymore."
}
