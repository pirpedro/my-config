#!/bin/bash

load "$(pwd)"/test_helper/helper.bash

recipe_name="test_recipe"

function setup {
  my_init
  local root_dir=$(my config --prefix)
  for file in $(find -L "$root_dir" -name "${recipe_name}*"); do
    if [ -f "$file" ]; then
      rm "$file"
    fi
  done
}

function teardown {
  root_dir=$(my config --prefix)
  for file in $(find -L "$root_dir" -name "${recipe_name}*"); do
    if [ -f "$file" ]; then
      rm "$file"
    fi
  done
}

@test "config disable - without arguments" {
  run my config disable && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config disable - with a no existent recipe" {
  run my config disable "notarecipe" && assert_failure
  assert_output "notarecipe is already disabled or not exist."
}

@test "config disable - with an already disabled recipe" {
  my config new "$recipe_name"
  run my config disable "$recipe_name" && assert_failure
  assert_output "$recipe_name is already disabled or not exist."
}

@test "config disable - an enabled recipe" {
  my config new "$recipe_name"
  my config enable "$recipe_name"
  run my config disable "$recipe_name" && assert_success
}

@test "config disable - check without arguments" {
  run my config disable -c && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config disable - check with a no existent recipe" {
  run my config disable -c "notarecipe" && assert_success
}

@test "config disable - check with an already disabled recipe" {
  my config new "$recipe_name"
  run my config disable -c "$recipe_name" && assert_success
}

@test "config disable - check an enabled recipe" {
  my config new "$recipe_name"
  my config enable "$recipe_name"
  run my config disable -c "$recipe_name" && assert_failure
}
