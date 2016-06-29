#!/bin/bash
source $3/functions.sh

case "$1" in
install)
    if [ ! -e ~/.bashrc ]; then
        touch ~/.bashrc
    fi

    if [ ! -e ~/.bash_profile ]; then
        touch ~/.bash_profile
    fi

    [ -d ~/.bash] || mkdir ~/.bash

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

;;
remove)
;;
esac
