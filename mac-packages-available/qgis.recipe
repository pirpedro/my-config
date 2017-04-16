#!/bin/bash
source $MY_CONFIG_EXT/functions.sh

my_require homebrew
case "$1" in
install)
  my_brew_install python
  brew linkapps python
  hash -r python

  my_brew_tap osgeo/osgeo4mac
  my_brew_install osgeo/osgeo4mac/qgis
  sudo ln -s /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python /Library/Python/2.7/site-packages/matplotlib-override
  my_env 'PYTHONPATH' '/usr/local/lib/python2.7/site-packages:$PYTHONPATH'
  brew linkapps qgis-28
  pip install psycopg2

;;
remove)
;;
esac
