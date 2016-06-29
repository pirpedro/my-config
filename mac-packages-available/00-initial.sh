#!/bin/bash
source $3/functions.sh

_set_env(){

	if [ ! -e ~/.profile ]; then
		touch ~/.profile
	fi

	if [ ! -e /etc/launchd.conf ]; then
		touch /etc/launchd.conf
	fi

  [ -d ~/.bash] || mkdir ~/.bash
  touch ~/.bash/my-config.sh
  chmod +x ~/.bash/my-config.sh

  echo "###############   my-config configuration script   ###############
if [ -d ~/.bash ]; then
   for i in ~/.bash/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> ~/.profile

  __my_env "alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'"
	__my_env "alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'"


  #TODO copy ENV/Fonts ~/Library/Fonts

    sudo echo "###############   my-config configuration script   ###############
if [ -d /etc/profile.d ]; then
   for i in /etc/profile.d/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> /etc/profile

touch ~/Library/LaunchAgents/environment.plist
touch ~/Library/LaunchAgents/environment.user.plist
touch ~/.bash/my-config-plist
sudo echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>environment</string>
    <key>ProgramArguments</key>
    <array>
            <string>~/.bash/my-config-plist</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>WatchPaths</key>
    <array>
        <string>~/.bash/my-config-plist</string>
    </array>
</dict>
</plist>" >> ~/Library/LaunchAgents/environment.plist

sudo echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>environment</string>
    <key>ProgramArguments</key>
    <array>
            <string>~/.bash/my-config-plist</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>WatchPaths</key>
    <array>
        <string>~/.bash/my-config-plist</string>
    </array>
</dict>
</plist>" >> ~/Library/LaunchAgents/environment.user.plist

  launchctl load -w ~/Library/LaunchAgents/environment.user.plist
  sudo chown root ~/Library/LaunchAgents/environment.plist
  sudo launchctl load -w ~/Library/LaunchAgents/environment.plist

}

case "$1" in
install)
	_set_env
;;
remove)
;;
esac

