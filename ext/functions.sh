#!/bin/bash

BASH_PROFILE=$HOME/.profile

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
  echo "$1"
  exit 1
}

__exit(){
  echo "$1"
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

	if [ $(__is_mac) == "1" ]; then
		if [ ! -e /etc/launchd.conf ]; then
			touch /etc/launchd.conf
		fi

		if [ $(__exists launchctl) == "1"  ]; then
			launchctl setenv $1 $2
		fi

		echo setenv $1 $2 >> /etc/launchd.conf
	fi

	if [ ! -e $BASH_PROFILE ]; then
		touch $BASH_PROFILE
	fi

	export $1=$2
	echo export $1=$2 >> $BASH_PROFILE

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
        myPathRemove $1 $2
	local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
	myEnv PATH $PATH
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      echo "Upgrading Homebrew ..."
      brew upgrade "$@"
    else
      echo "Already using the latest version of Homebrew. Skipping ..."
    fi
  else
    echo "You need to install homebrew first"
    brew install "$@"
  fi
}

brew_is_installed() {
  brew list -1 | grep -Fqx "$1"
}

brew_is_upgradable() {
  ! brew outdated --quiet "$1" >/dev/null
}

brew_tap_is_installed() {
  brew tap | grep -Fqx "$1"
}

brew_tap() {
  if ! brew_tap_is_installed "$1"; then
    echo "Tapping $1..."
    brew tap "$1" 2> /dev/null
  fi
}

brew_cask_expand_alias() {
  brew cask info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_cask_is_installed() {
  local NAME
  NAME=$(brew_cask_expand_alias "$1")
  brew cask list -1 | grep -Fqx "$NAME"
}

app_is_installed() {
  local app_name
  app_name=$(echo "$1" | cut -d'-' -f1)
  find /Applications -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

brew_cask_install() {
  if app_is_installed "$1" || brew_cask_is_installed "$1"; then
    echo "$1 is already installed. Skipping..."
  else
    echo "Installing $1..."
    brew cask install "$@"
  fi
}



