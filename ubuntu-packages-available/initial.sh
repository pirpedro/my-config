#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

case "$1" in
install)
    if [ ! -e ~/.bashrc ]; then
        touch ~/.bashrc
    fi

    if [ ! -e ~/.bash_profile ]; then
        touch ~/.bash_profile
    fi

    [ -d ~/.bash] || mkdir ~/.bash
    touch ~/.bash/my-config.sh
    chmod +x ~/.bash/my-config.sh
    touch ~/.bash/.bash_aliases
  	chmod +x ~/.bash/.bash_aliases

    echo "###############   my-config configuration script   ###############
if [ -d ~/.bash ]; then
   for i in ~/.bash/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> ~/.bash_profile

    echo "###############   my-config configuration script   ###############
if [ -d ~/.bash ]; then
   for i in ~/.bash/*.sh; do
      if [ -r \$i ]; then
         . \$i
      fi
   done
   unset i
fi
##################################################################" >> ~/.bashrc

#Ubuntu themes
sudo apt-get install -y unity-tweak-tool
sudo apt-add-repository ppa:tista/adapta -y
sudo apt-get install adapta-gtk-theme

sudo apt-add-repository ppa:numix/ppa -y
sudo apt-get update
sudo apt-get install numix-icon-theme-circle

;;
remove)
;;
esac
