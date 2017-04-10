#!/bin/bash

load $(pwd)/test_helper/helper.bash

recipe_name="test_recipe"

@test "config new - no argument passed" {
  run my config new && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config new - create new recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
  rm "$output"
}

@test "config new - try to recreate an disabled recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
  local file_path="$output"
  my config disable "$recipe_name" || true
  run my config new "$recipe_name" && assert_failure
  assert_output "$recipe_name recipe already exist."
  rm "$file_path"
}

@test "config new - try to recreate an enabled recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
  local file_path="$output"
  my config enable "$recipe_name" || true
  run my config new "$recipe_name" && assert_failure
  assert_output "$recipe_name recipe already exist."
  rm "$file_path"
}
