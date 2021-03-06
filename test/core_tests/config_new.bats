#!/bin/bash

load "$(pwd)"/test_helper/helper.bash

recipe_name="test_recipe"

function setup {
  my_init
  local root_dir=$(my config --prefix)
  for file in $(sudo find "$root_dir"  -name '"$recipe_name"*'); do
    if [ -f "$file" ]; then
      sudo rm "$file"
    fi
  done
}

function teardown {
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}*"); do
    if [ -f "$file" ]; then
      sudo rm "$file"
    fi
  done
}

@test "config new - no argument passed" {
  run my config new && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config new - create new recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
}

@test "config new - try to recreate an disabled recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
  my config disable "$recipe_name" || true
  run my config new "$recipe_name" && assert_failure
  assert_output "$recipe_name recipe already exist."
}

@test "config new - try to recreate an enabled recipe" {
  run my config new "$recipe_name" && assert_success
  assert [ -f "$output" ]
  my config enable "$recipe_name" || true
  run my config new "$recipe_name" && assert_failure
  assert_output "$recipe_name recipe already exist."
}

@test "config new - all recipes must started disabled" {
  run my config new "$recipe_name" && assert_success
  run my config disable -c "$recipe_name" && assert_success
}
