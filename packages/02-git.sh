#!/bin/bash
source $2/functions.sh

case "$1" in
install)
	git config --global user.email "pir.pedro@gmail.com"
	git config --global user.name "Pedro"
             git config --global push.default simple
	git config --global core.excludesfile ~/.git/gitignore

;;
remove)
;;
esac
