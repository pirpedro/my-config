#!/bin/bash

load "$(pwd)"/test_helper/helper.bash

recipes_dir="$(my config --recipe-path)"
resource_dir="$(my config --resource-path)"
recipe_name="recipetest"
recipe="$recipes_dir/$recipe_name.recipe"
recipe_resources_name="reciperesources"
recipe_with_resources="$recipes_dir/$recipe_resources_name.recipe"
resource_name="testresource"
resource_file="$resource_dir/$recipe_resources_name/$resource_name.template"
resource_file_content="content of resource file."

setup() {
  my_init
  [ -d "$resource_dir" ] || mkdir -p "$resource_dir"
  [ -d "$resource_dir/$recipe_resources_name" ] || mkdir -p "$resource_dir/$recipe_resources_name"
  [ -f "$recipe" ] || { touch "$recipe";
echo "#!/bin/bash
source \$MY_CONFIG_EXT/functions.sh" >> "$recipe"; }
  [ -f "$recipe_with_resources" ] || { touch "$recipe_with_resources";
  echo "#!/bin/bash
  source \$MY_CONFIG_EXT/functions.sh" >> "$recipe_with_resources"; }
  [ -f "$resource_file" ] || { touch "$resource_file";
                            echo "$resource_file_content" >> "$resource_file"; }
  grep -v "^$recipe_name\$" ~/.myconfig/installed > ~/.myconfig/installed.tmp
  mv -f ~/.myconfig/installed.tmp ~/.myconfig/installed

  grep -v "^$recipe_resources_name\$" ~/.myconfig/installed > ~/.myconfig/installed.tmp
  mv -f ~/.myconfig/installed.tmp ~/.myconfig/installed
}

teardown() {
    [ ! -d "$resource_dir/$recipe_resources_name" ] || rm -rf "${resource_dir:?}/$recipe_resources_name"
    [ ! -f "$recipe" ] || rm "$recipe"
    [ ! -f "$recipe_with_resources" ] || rm "$recipe_with_resources"
}

@test "my_resource - without argument" {
  echo "my_resource" >> $recipe_with_resources
  run my config install -v "$recipe_resources_name" && assert_success
  assert_output --partial "Recipe $recipe_resources_name: No resource passed."
}

@test "my_resource - not a resource file" {
  echo "my_resource wrong_file" >> $recipe_with_resources
  run my config install -v "$recipe_resources_name" && assert_success
  assert_output --partial "Recipe $recipe_resources_name: Resource wrong_file not found."
}

@test "my_resource - real resource file" {
  echo "my_resource $resource_name" >> $recipe_with_resources
  run my config install "$recipe_resources_name" && assert_success
  assert_output "$resource_file_content"
}

@test "my_resource - recipe without resource" {
  echo "my_resource wrong_file" >> $recipe
  run my config install -v "$recipe_name" && assert_success
  assert_output --partial "Recipe $recipe_name: Resource wrong_file not found."

}
