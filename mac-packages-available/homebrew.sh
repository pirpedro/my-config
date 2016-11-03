#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
	if [ $(__exists brew) == "1" ]; then
		echo "HomeBrew already installed";
             	return 1;
	fi

	if [ $(__exists ruby) == "1" ]; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew prune
		brew doctor
		brew update
		brew upgrade

    brew install bash-completion
    __my_env 'if [ -f $(brew --prefix)/etc/bash_completion ]; then . $(brew --prefix)/etc/bash_completion; fi'

		# install cask
        brew cask
        __brew_tap caskroom/versions
        __brew_tap homebrew/science
        __brew_tap caskroom/fonts
        __brew_tap caskroom/eid
        __brew_install homebrew/completions/brew-cask-completion

    __brew_install gnu-sed --with-default-names

	else
		echo "Ruby not installed";
	fi

;;
remove)
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
   sudo chmod 0755 /usr/local
   sudo chgrp wheel /usr/local

;;
esac
