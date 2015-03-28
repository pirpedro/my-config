#!/bin/bash

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

myPath(){
	SCRIPT=$(readlink -f "$1")
	SCRIPTPATH=$(dirname "$SCRIPT")
	echo $SCRIPTPATH
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
}

includePath(){
	if [ ${$PATH/$1} = "$PATH" ]; then
		if [ $(exists export) == "1" ]; then
			export PATH=$PATH:$1
		fi
	fi
}
