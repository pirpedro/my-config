#!/bin/bash

dashless=$(basename -- "$0" | sed -e 's/-/ /')

usage() {
  echo "usage: $dashless $USAGE"
}

case "$1" in
  -h)
  echo "$LONG_USAGE"
  exit
esac
