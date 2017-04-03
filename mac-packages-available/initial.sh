#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

_set_env(){

	if [ ! -e ~/.profile ]; then
		touch ~/.profile
	fi

  [ -d ~/.bash ] || mkdir ~/.bash
  [ -f ~/.bash/my-config.sh ] || touch ~/.bash/my-config.sh
  [ -f ~/.bash/.bash_aliases ] || touch ~/.bash/.bash_aliases
  [ -f ~/.bash/.bash_path ] || touch ~/.bash/.bash_path
  chmod +x ~/.bash/my-config.sh
  chmod +x ~/.bash/.bash_aliases
  chmod +x ~/.bash/.bash_path

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

my_alias showFiles 'defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
my_alias hideFiles 'defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

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

echo "grep \"^export\" $PROFILE | while IFS=' =' read ignoreexport envvar ignorevalue; do
  launchctl setenv \${envvar} \${!envvar}
done
grep \"^export\" $PATH_FILE | while IFS=' =' read ignoreexport envvar ignorevalue; do
  launchctl setenv \${envvar} \${!envvar}
done
" >> ~/.bash/my-config-plist

sudo echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>environment</string>
  <key>ProgramArguments</key>
  <array>
    <string>bash</string>
    <string>-l</string>
    <string>-c</string>
    <string>\$HOME/.bash/my-config-plist</string>
  </array>
  <key>KeepAlive</key>
  <false/>
  <key>RunAtLoad</key>
  <true/>
  <key>WatchPaths</key>
  <array>
      <string>\$HOME/.bash/my-config-plist</string>
  </array>
</dict>
</plist>" | tee -a ~/Library/LaunchAgents/environment.plist ~/Library/LaunchAgents/environment.user.plist

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
