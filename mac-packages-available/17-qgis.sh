#!/bin/bash

source $3/functions.sh

case "$1" in
install)
  brew install python
  brew linkapps python
  hash -r python

  brew tap osgeo/osgeo4mac
  brew install osgeo/osgeo4mac/qgis
  sudo ln -s /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python /Library/Python/2.7/site-packages/matplotlib-override
  __my_env 'PYTHONPATH' '/usr/local/lib/python2.7/site-packages:$PYTHONPATH'
  brew linkapps qgis-28
  pip install psycopg2

;;
remove)
;;
esac
