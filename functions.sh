#!/bin/bash

BASH_PROFILE=$HOME/.profile

random(){
	echo $(cat /dev/urandom | base64 | tr -dc A-Za-z0-9_ | head -c8)
}

abort(){
  echo "$1"
  exit 1
}

isMac(){
   if [[ "$OSTYPE" == "darwin"* ]]; then
     echo 1;
   else
     echo 0;
   fi
}

isLinux(){        
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
    		echo 1;
	else
		echo 0;
	fi
}

exists(){
	type -P $1 &>/dev/null && echo 1 || echo 0;

}

myEnv(){
	
	if [ $(isMac) == "1" ]; then
		if [ ! -e /etc/launchd.conf ]; then
			touch /etc/launchd.conf
		fi

		if [ $(exists launchctl) == "1"  ]; then
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

myPathRemove(){
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

myPath(){
        myPathRemove $1 $2
	local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
	myEnv PATH $PATH
}


