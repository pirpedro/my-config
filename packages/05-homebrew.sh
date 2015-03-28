#!/bin/bash
source functions.sh

case "$1" in
install)
        if [ $(exists brew) == "1" ]; then
		echo "HomeBrew already installed";
                return 1;
	fi

	if [ $(isMac) == "1" ]; then
		echo "mac"
		if [ $(exists ruby) == "1" ]; then
			if [ ! -d /usr/local ]; then
				mkdir -p /usr/local/bin;
			fi
			cd /usr/local;
			mkdir homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew;
			ln -s /usr/local/homebrew/bin/brew /usr/local/bin/brew	
			brew update
			brew upgrade
		else
			echo "Ruby not installed";
		fi
	fi

;;
remove)
;;
esac
