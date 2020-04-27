#!/bin/bash

# shellcheck source=ext/bash-common/bin/sh-common
source $MY_CONFIG_EXT/sh-common

ENV_DIR=$HOME/.myenv
PROFILE=$ENV_DIR/config.sh
ALIAS_FILE=$ENV_DIR/aliases.sh
PATH_FILE=$ENV_DIR/path
CONFIGURATION_FOLDER="$HOME/.myconfig"
HOOK_FOLDER=$CONFIGURATION_FOLDER/hooks

#format the script name for a user friendly package name
__format_script_name(){
  ! empty "$1" || die "No argument passed to '$0' function."
  echo "$(basename ${1%.*})" #| sed 's/^.*\///'
}

#load and export any variable in a configuration file
__load_config_file(){
  ! empty "$1" || die "No argument passed to '$0' function."
  local configfile=$1
  local configfile_secured='/tmp/$(random).cfg'

  # check if the file contais something we don't want
  if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
    note "Config file is unclean, cleaning it..." >&2
    egrep '^#|^[^ ]*=[^;&]*'  "configfile" > "configfile_secured"
    configfile="$configfile_secured"
  fi

 #   typeset -a config #init array
 #   config=( #set default values
 #         [host]="teste"
 #         [host2]="teste2"
 #     )

  while read line || [ -n "$line" ]
  do
    if echo $line | grep -F = &>/dev/null
    then
      varname=$(echo "$line" | cut -d '=' -f 1)
      export $varname="$(echo "$line" | cut -d '=' -f 2-)"
    fi
  done < "$configfile"
}

#useful which will give you the full directory name of the script no matter where it is being called
#from including any combination of aliases, source, bash -c, symlinks, etc..
__current_location(){
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

__is_mac(){ [[ "$OSTYPE" == "darwin"* ]]; }
__is_linux(){ [ "$OSTYPE" == "linux-gnu" ]; }
#check if command exist.
__exists(){
  ! empty "$1" || die "No argument passed to '$0' function."
  type -P $1 &>/dev/null;
}

my_env(){
  ! empty "$1" || die "No argument passed to '$0' function."
	if [ $# -eq 1 ]; then
    if ! grep -xq "$1" $PROFILE; then
      echo $1 >> $PROFILE
      eval "$1"
    fi
    return
  fi

  if __is_mac && __exists launchctl; then
  	launchctl setenv $1 $2
	fi
	export $1=$2
  if ! grep -xq "export $1=$2"; then
	   echo export $1=$2 >> $PROFILE
  fi
}

my_alias(){
  if [[ ! $# -eq 2  ]]; then
    die "You need to pass two parameters."
  fi
  echo "alias $1='$2'" >> $ALIAS_FILE
}

my_link(){
  ln -sfn $1 $2
}

my_path_remove(){
  ! empty "$1" || die "No argument passed to '$0' function."

  local NEWPATH DIR
  #try to recover from bash file
  local PATH_VARIABLE
  PATH_VARIABLE=$(cat $PATH_FILE)
  #remove last part of string that contains '$PATH'
  PATH_VARIABLE=${PATH_VARIABLE%%':$PATH'}
  #remove front part that contains 'PATH='
  PATH_VARIABLE=${PATH_VARIABLE##'export PATH='}
  PATH_VARIABLE=`echo $PATH_VARIABLE | sed -e 's/:/ /g'`
  for DIR in $PATH_VARIABLE ; do
    if ! equals "$DIR" "$1"; then
      NEWPATH=${NEWPATH}$DIR:
    fi
  done
  PATH=`echo $PATH | sed -e "s%$1:%%g"` # using '%' in sed because $1 contains slashes
  if ! empty "$NEWPATH"; then
    export PATH="$PATH"
    echo "export PATH=$NEWPATH\$PATH" > $PATH_FILE
  else
    echo "" > $PATH_FILE
  fi
}

my_path(){
  ! empty "$1" || die "No argument passed to '$0' function."
  my_path_remove "$1"
	local PATH_VARIABLE
  PATH_VARIABLE="$(cat $PATH_FILE)"
  #remove last part of string that contains '$PATH'
  PATH_VARIABLE=${PATH_VARIABLE%%':$PATH'}
  #remove front part that contains 'export PATH='
  PATH_VARIABLE=${PATH_VARIABLE##'export PATH='}
  local NEWPATH="$1"
  export PATH="$NEWPATH:$PATH"
  if ! empty "$PATH_VARIABLE"; then
    NEWPATH="$NEWPATH:$PATH_VARIABLE"
  fi
  echo "export PATH=$NEWPATH:\$PATH" > $PATH_FILE
}

my_require() {
  my config install "$@"
}

my_resource() {
  recipe="$(__format_script_name $0)"
  ! empty "$1" || { warn "Recipe $recipe: No resource passed."; return "${FLAG_FALSE}"; }
  [ -f "$PACKAGE_EXTERNAL/$recipe/$1.template" ] || { warn "Recipe $recipe: Resource $1 not found.";
                                                      return "${FLAG_FALSE}"; }
  cat "$PACKAGE_EXTERNAL/$recipe/$1.template"
}

__create_if_not_exist(){
  local dir
  if [ ! -f "$1" ]; then
    dir=$(dirname "$1")
    [ -d "$dir" ] || mkdir -p "$dir"
    touch "$1"
  fi
}

INSTALLED_FILE=$CONFIGURATION_FOLDER/installed
__required(){
  if [[ ! $# -eq 2  ]]; then
    die "You need to pass two parameters."
  fi
  local ACTION=$1
  __create_if_not_exist $INSTALLED_FILE
  case "$ACTION" in
    check )
      grep "^$2\$" $INSTALLED_FILE >/dev/null ;
      ;;
    install )
      grep "^$2\$" $INSTALLED_FILE || echo "$2" >> $INSTALLED_FILE
      ;;
    remove )
      grep -v "^$2\$" $INSTALLED_FILE > $INSTALLED_FILE.tmp
      mv -f $INSTALLED_FILE.tmp $INSTALLED_FILE
      ;;
  esac
}



my_config_file(){
  #leaves only the first element of the config variable
  echo "${1%%.*}"
}

my_config(){
  local file
  file="$1"; shift;
  __create_if_not_exist "$CONFIGURATION_FOLDER/$file"
  git config --file "$CONFIGURATION_FOLDER/$file" "$@"
}
my_config_get() {
  my_config "$(my_config_file $1)" --get "$1"
}

my_config_get_regex(){
  my_config "$(my_config_file $1)" --get-regexp "$1"
}

my_config_set() {
  my_config "$(my_config_file $1)" "$1" "$2"
}

my_config_unset(){
  my_config "$(my_config_file $1)" --unset "$1"
}

my_config_remove_section(){
  my_config "$(my_config_file $1)" --remove-section "$1"
}

my_brew_install() {
  if _brew_is_installed "$1"; then
    if _brew_is_upgradable "$1"; then
      note "Upgrading $1 ..."
      brew upgrade "$@"
    else
      note "Already using the latest version of $1. Skipping ..."
    fi
    exit
  else
    note  "Installing $1"
    brew install "$@"
  fi
}

my_brew_upgrade() {
  if _brew_is_upgradable "$1"; then
    note "Upgrading $1..."
    brew upgrade "$@"
  else
    note "Upgrade failed!"
  fi
}

my_brew_uninstall() {
  if _brew_is_installed "$1"; then
    note "Removing $1..."
    brew unistall "$1"
  fi
}

_brew_is_installed() {
  brew list -1 | grep -Fqx "$1"
}

_brew_is_upgradable() {
  ! brew outdated --quiet "$1" >/dev/null
}

_brew_tap_is_installed() {
  brew tap | grep -Fqx "$1"
}

my_brew_tap() {
  if ! _brew_tap_is_installed "$1"; then
    note "Tapping $1..."
    brew tap "$1" 2> /dev/null
  fi
}

_brew_cask_expand_alias() {
  brew cask info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

_brew_cask_is_installed() {
  local NAME
  NAME=$(_brew_cask_expand_alias "$1")
  brew cask list -1 | grep -Fqx "$NAME"
}

_app_is_installed() {
  local app_name
  app_name=$(echo "$1" | cut -d'-' -f1)
  find /Applications -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

my_brew_cask_install() {
  if _app_is_installed "$1" || _brew_cask_is_installed "$1"; then
    note "$1 is already installed. Skipping..."
  else
    note "Installing $1..."
    brew cask install "$@"
  fi
}

__create_hooks_folder(){
  [ -d $CONFIGURATION_FOLDER ] || mkdir -p $CONFIGURATION_FOLDER
}

__open_hook_file(){
  local scriptfile
  __create_hooks_folder
  ! empty "$1" || die "${FUNCNAME[0]}: No argument passed."
  scriptfile=$HOOK_FOLDER/$1
  __create_if_not_exist "$scriptfile"
  if empty_file "$scriptfile"; then
    echo "#!/usr/bin/env bash" >> "$scriptfile"
  fi
  "${EDITOR:-/usr/bin/vi}" $scriptfile
  chmod +x $scriptfile
}

__run_hook(){
  local target action scriptfile exitcode
  target="$1"; shift;
  action="$1"; shift;
  scriptfile="${HOOK_FOLDER}/${target}.${action}"
  exitcode=0
  if [ -x "$scriptfile" ]; then
    "$scriptfile" "$@"
    exitcode=$?
    if ! equals ${exitcode} 0; then
      die "Hook ${action} hook for ${target} ended with exit code ${exitcode}"
    fi
  fi

}
