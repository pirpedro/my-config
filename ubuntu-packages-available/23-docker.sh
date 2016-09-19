#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-get install apt-transport-https ca-certificates
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  if [[ -e /etc/apt/sources.list.d/docker.list ]]; then
    > /etc/apt/sources.list.d/docker.list
  fi

  echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -sc) main" >> /etc/apt/sources.list.d/docker.list

;;
remove)
;;
esac
