#!/usr/bin/env bash

load "$(pwd)"/test_helper/helper.bash

recipe_name="test_recipe"

function setup {
  my_init
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
}

function teardown {
  my_init
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
}

@test "config enable - without arguments" {
  run my config enable && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config enable - with a no existent recipe" {
  run my config enable "notarecipe" && assert_failure
  assert_output "notarecipe is already enabled or not exist."
}

@test "config enable - an disabled recipe" {
  my config new "$recipe_name"
  run my config enable "$recipe_name"
  assert_success
}

@test "config enable - with an already enabled recipe" {
  my config new "$recipe_name"
  my config enable "$recipe_name"
  run my config enable "$recipe_name" && assert_failure
  assert_output "$recipe_name is already enabled or not exist."
}

@test "config enable - check without arguments" {
  run my config enable -c && assert_failure
  assert_output "You need to pass a recipe name."
}

@test "config enable - check with a no existent recipe" {
  run my config enable -c "notarecipe" && assert_failure
}

@test "config enable - check with an already enabled recipe" {
  my config new "$recipe_name"
  my config enable "$recipe_name"
  run my config enable -c "$recipe_name" && assert_success
}

@test "config enable - check an disabled recipe" {
  my config new "$recipe_name"
  run my config enable -c "$recipe_name" && assert_failure
}
