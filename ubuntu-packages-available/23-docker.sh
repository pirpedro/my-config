#!/bin/bash
source $3/functions.sh

case "$1" in
install)
  sudo apt-get install apt-transport-https ca-certificates
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  if [[ -e /etc/apt/sources.list.d/docker.list ]]; then
    > /etc/apt/sources.list.d/docker.list
  fi

  echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/docker.list
  sudo apt-get update
  sudo apt-get purge lxc-docker
  apt-cache policy docker-engine
  #it’s recommended to install the linux-image-extra-* kernel packages. The linux-image-extra-* packages allows you use the aufs storage driver.
  sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
  sudo apt-get install docker-engine

  sudo groupadd docker
  sudo usermod -aG docker $USER

;;
remove)
  sudo apt-get purge docker-engine
  sudo apt-get autoremove --purge docker-engine
  rm -rf /var/lib/docker
;;
start)
  sudo systemctl start docker
;;
stop)
;;
esac
