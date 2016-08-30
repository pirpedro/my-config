#!/bin/bash
source $3/functions.sh

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
	else
		echo "Ruby not installed";
	fi

;;
remove)
#	set -e

#	/usr/bin/which -s git || abort "brew install git first!"
#	test -d /usr/local/.git || abort "brew update first!"

#	cd `brew --prefix`
#	git checkout master
#	git ls-files -z | pbcopy
#	rm -rf Cellar
#	bin/brew prune
#	pbpaste | xargs -0 rm
#	rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
#	test -d Library/LinkedKegs && rm -r Library/LinkedKegs
#	rmdir -p bin Library share/man/man1 2> /dev/null
#	rm -rf .git
#	rm -rf ~/Library/Caches/Homebrew
#	rm -rf ~/Library/Logs/Homebrew
#	rm -rf /Library/Caches/Homebrew

   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
   sudo chmod 0755 /usr/local
   sudo chgrp wheel /usr/local

;;
esac
