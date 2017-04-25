# my config

## Getting Started
The `my config` command handle installation of services (__recipes__).

### Recipes
Basically, __recipes__ are shell scripts with `.recipe` extension that contains code that you judge necessary to install a specific service.

#### Example
In ubuntu version, run:
```
cat $(my config --all-recipe-path)/ansible.recipe
```
The output is similar to:
```
#!/bin/bash
#shellcheck source=ext/functions.sh
source $MY_CONFIG_EXT/functions.sh

case "$1" in
  install)
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt-get update -y
    sudo apt-get install ansible -y
  ;;
esac
```

## Commands
-   `install` - install a named recipe.
-   `remove` - remove a named recipe.
-   `list` - list all enabled recipes.
-   `new` - create a new recipe using template
-   `enable` - enable a named recipe to be installed if you want.
-   `disable` - disable the installation/removal of a named recipe.


## Examples
1.  Remove the __ansible__ recipe from the enabled list to be installed.
    ```
      my config disable ansible
    ```
2.  Check if __ansible__ recipe is enabled to use.
    ```
      my config enable -c ansible
    ```
3.  List all enabled recipes
    ```
    my config list
    ```
4.  Create a recipe for __firefox__ installation.
    ```
    my config new firefox
    ```
    Then put your custom code on it.
    ```
    nano $(my config --all-recipe-path)/firefox.recipe
    ```
5.  Install your custom __firefox__ recipe.
    ```
    my config enable firefox
    my config install firefox
    ```

Go back to [readme](../README.md) for installation steps and usage examples.
