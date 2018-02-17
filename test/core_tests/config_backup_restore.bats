#!/usr/bin/env bash

load "$(pwd)"/test_helper/helper.bash

recipe_name="test_recipe"
hooks_folder="$HOME/.myconfig/hooks"

assert_hook_exist(){
  local target action
  target="$1"
  action="${2:-install}"
  assert [ -f $hooks_folder/$target.$action ]
}


function setup {
  my_init
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done

  for file in "$(my config --recipe-path)"/*.recipe; do
    rm $file
  done
  [ ! -d $hooks_folder ] || rm -rf $hooks_folder
  my config enable initial  > /dev/null
  my config new $recipe_name > /dev/null
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

  export EDITOR=touch
}

function teardown {
  local root_dir
  root_dir=$(my config --prefix)
  for file in $(sudo find -L "$root_dir" -name "${recipe_name}"*); do
    if [ -f "$file" ] || [ -L "$file" ]; then
      sudo rm "$file"
    fi
  done
  [ ! -d $hooks_folder ] || rm -rf $hooks_folder
}

@test "config extra - No argument passed" {
  run my config extra && assert_failure
  assert_output "A target recipe must be informed."
}

@test "config extra - Hook to install a nonexistent recipe" {
  fake_name="whatever"
  run my config extra ${fake_name} && assert_success
  assert_hook_exist $fake_name
  assert_output -p "Hook to install ${fake_name} created."
}

@test "config extra - Hook to explicit install a nonexistent recipe" {
  fake_name="whatever"
  run my config extra ${fake_name} install && assert_success
  assert_hook_exist ${fake_name} "install"
  assert_output -p "Hook to install ${fake_name} created."
}

@test "config extra - Hook to explicit remove a nonexistent recipe" {
  fake_name="whatever"
  run my config extra ${fake_name} remove && assert_success
  assert_hook_exist ${fake_name} "remove"
  assert_output -p "Hook to remove ${fake_name} created."
}

@test "config extra - Hook to install an existing recipe" {
  run my config extra ${recipe_name} && assert_success
  assert_hook_exist ${recipe_name}
  assert_output -p "Hook to install ${recipe_name} created."
}

@test "config extra - Hook to explicit install an existing recipe" {
  run my config extra ${recipe_name} install && assert_success
  assert_hook_exist ${recipe_name} "install"
  assert_output -p "Hook to install ${recipe_name} created."
}

@test "config extra - Hook to explicit remove an existing recipe" {
  run my config extra ${recipe_name} remove && assert_success
  assert_hook_exist ${recipe_name} "remove"
  assert_output -p "Hook to remove ${recipe_name} created."
}

@test "config extra - Update an existing hook" {
  local filepath=${hooks_folder}/${recipe_name}.install
  run my config extra ${recipe_name} && assert_success
  echo "New content to file" >> ${filepath}
  run my config extra ${recipe_name} && assert_success
  run cat $filepath
  assert_line -n 1 "New content to file"
}

@test "config extra - Install with extra hook" {
  my config enable ${recipe_name}
  my config extra ${recipe_name}
  echo "echo 'Installed extra to ${recipe_name}'" >> ${hooks_folder}/${recipe_name}.install
  run my config install ${recipe_name} && assert_success
  assert_line -n 0 "Installed ${recipe_name}"
  assert_line -n 1 "Installed extra to ${recipe_name}"
}

@test "config extra - Install with extra remove hook" {
  my config enable ${recipe_name}
  my config extra ${recipe_name} remove
  echo "echo 'Remove extra to ${recipe_name}'" >> ${hooks_folder}/${recipe_name}.remove
  run my config install ${recipe_name} && assert_success
  assert_output "Installed ${recipe_name}"
}
