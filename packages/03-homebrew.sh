#!/bin/bash
source $2/functions.sh

case "$1" in
install)
        if [ $(exists brew) == "1" ]; then
		echo "HomeBrew already installed";
                return 1;
	fi

	if [ $(isMac) == "1" ]; then
		echo "mac"
		if [ $(exists ruby) == "1" ]; then
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"	
			brew doctor
			brew update
			brew upgrade
		else
			echo "Ruby not installed";
		fi
	fi

;;
remove)
	set -e
 
	/usr/bin/which -s git || abort "brew install git first!"
	test -d /usr/local/.git || abort "brew update first!"
 
	cd `brew --prefix`
	git checkout master
	git ls-files -z | pbcopy
	rm -rf Cellar
	bin/brew prune
	pbpaste | xargs -0 rm
	rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions 
	test -d Library/LinkedKegs && rm -r Library/LinkedKegs
	rmdir -p bin Library share/man/man1 2> /dev/null
	rm -rf .git
	rm -rf ~/Library/Caches/Homebrew
	rm -rf ~/Library/Logs/Homebrew
	rm -rf /Library/Caches/Homebrew

;;
esac
