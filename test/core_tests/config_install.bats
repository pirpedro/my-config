#!/usr/bin/env bash

load "$(pwd)"/test_helper/helper.bash

recipe_name="test_recipe"
require_recipe_name="require_recipe"

function setup {
  my_init
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
  for file in $(sudo find -L "$root_dir" -name "${require_recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done

  for file in "$(my config --recipe-path)"/*.recipe; do
    rm $file
  done
  my config enable initial  > /dev/null
  my config new $recipe_name > /dev/null
  my config new ${require_recipe_name} > /dev/null
  echo "#!/bin/bash
  source \$MY_CONFIG_EXT/functions.sh

  case \"\$1\" in
  install)
    echo \"Installed $recipe_name\"
  ;;
  remove)
    echo \"Removed $recipe_name\"
  ;;
esac" > "$(my config --all-recipe-path)/${recipe_name}.recipe"

  echo "#!/bin/bash
  source \$MY_CONFIG_EXT/functions.sh

  my_require $recipe_name
  case \"\$1\" in
  install)
    echo \"Installed $require_recipe_name\"
  ;;
  remove)
    echo \"Removed $require_recipe_name\"
  ;;
esac" > "$(my config --all-recipe-path)/${require_recipe_name}.recipe"
}

function teardown {
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
  for file in $(sudo find -L "$root_dir" -name "${require_recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
}


@test "config install - without argument" {
  run my config install && assert_failure
  assert_output "__load: No argument passed."
}

@test "config install - not a real recipe" {
  local fake_name
  fake_name="whatever"
  run my config install ${fake_name} && assert_failure
  assert_output "Configuration file for ${fake_name} not found."
}

@test "config install - not enabled recipe" {
  run my config install ${recipe_name} && assert_failure
  assert_output "Configuration file for ${recipe_name} not found."
}

@test "config install - an enabled recipe" {
  my config enable ${recipe_name}
  run my config install ${recipe_name} && assert_success
  assert_output "Installed $recipe_name"
}

@test "config install - with dependency in configuration file" {
  my config enable ${recipe_name}
  my config enable ${require_recipe_name}
  run my config install ${require_recipe_name} && assert_success
  assert_line -n 0 "Installed $recipe_name"
  assert_line -n 1 "Installed $require_recipe_name"
}
