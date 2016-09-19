#!/bin/bash

BASH_DIR=$HOME/.bash
PLIST=$BASH_DIR/my-config-plist
PROFILE=$BASH_DIR/my-config.sh

#format the script name for a user friendly package name
__format_script_name(){
        echo ${1%.*} | sed 's/^.*-//'
}

__verbosity(){
   if [ "$1" == "on" ]; then
        export MY_CONFIG_VERBOSE=1;
    else
        export MY_CONFIG_VERBOSE=0;
   fi
}

__log(){
  if [ "$MY_CONFIG_VERBOSE" == "1" ]; then
      echo "$1"
  fi
}

#load and export any variable in a configuration file
 __load_config_file(){
    local configfile=$1
    local configfile_secured='/tmp/$(__random).cfg'

    # check if the file contais something we don't want
    if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
      __log "Config file is unclean, cleaning it..." >&2
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
        export $varname=$(echo "$line" | cut -d '=' -f 2-)
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

#generate a random value
__random(){
	echo $(cat /dev/urandom | base64 | tr -dc A-Za-z0-9_ | head -c8)
}

#exit script
__abort(){
  __log $1
  exit 1
}

__exit(){
  __log $1
  exit 0
}

__is_mac(){
   if [[ "$OSTYPE" == "darwin"* ]]; then
     echo 1;
   else
     echo 0;
   fi
}

__is_linux(){
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
    		echo 1;
	else
		echo 0;
	fi
}

__exists(){
	type -P $1 &>/dev/null && echo 1 || echo 0;

}

__my_env(){

	if [ $# -eq 1 ]; then
    echo $1 >> $PROFILE
    return
  fi

  if [ $(__is_mac) == "1" ]; then
    #defaults write /Users/Pedro/.MacOSX/environment.plist PYTHONPATH -string "/usr/local/lib/python2.7/site-packages"
    echo setenv $1 $2 >> $PLIST
		if [ $(__exists launchctl) == "1"  ]; then
	  	launchctl setenv $1 $2
		fi

	fi
	export $1=$2
	echo export $1=$2 >> $PROFILE
}

__my_alias(){
  if [[ ! $# -eq 2  ]]; then
    __log "You need to pass two parameters."
    exit
  fi

  echo alias $1=\'$2\' >> ~/.bash/.bash_aliases

}

__my_link(){
  echo ln -s $1 $2
}

__my_sync(){
  SOURCE=$(echo "'$1'" | sed 's/~\//\/home\//g')
  SOURCE=$sync_folder$SOURCE
  local TARGET
  if [[ $# -eq 1 ]]; then
    TARGET="$1"
  else
    TARGET="$2"
  fi
  echo $SOURCE
  __my_link $SOURCE $TARGET
}

__my_path_remove(){
	local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

__my_path(){
  __my_path_remove $1 $2
	local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
	__my_env PATH $PATH
}

__brew_install() {
  if _brew_is_installed "$1"; then
    if _brew_is_upgradable "$1"; then
      __log "Upgrading $1 ..."
      brew upgrade "$@"
    else
      __log "Already using the latest version of $1. Skipping ..."
    fi
    exit
  else
    __log  "Installing $1"
    brew install "$@"
  fi
}

__brew_upgrade() {
  if _brew_is_upgradable "$1"; then
    __log "Upgrading $1..."
    brew upgrade "$@"
  else
    __log "Upgrade failed!"
  fi
}

__brew_uninstall() {
  if _brew_is_installed "$1"; then
    __log "Removing $1..."
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

__brew_tap() {
  if ! _brew_tap_is_installed "$1"; then
    echo "Tapping $1..."
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

__brew_cask_install() {
  if _app_is_installed "$1" || _brew_cask_is_installed "$1"; then
    echo "$1 is already installed. Skipping..."
  else
    echo "Installing $1..."
    brew cask install "$@"
  fi
}
