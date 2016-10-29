#!/bin/bash
source $3/functions.sh

#ImageMagick® is a software suite to create, edit, compose, or convert bitmap images.
#It can read and write images in a variety of formats (over 200) including PNG, JPEG,
#JPEG-2000, GIF, TIFF, DPX, EXR, WebP, Postscript, PDF, and SVG. Use ImageMagick to
#resize, flip, mirror, rotate, distort, shear and transform images, adjust image
#colors, apply various special effects, or draw text, lines, polygons, ellipses and
#Bézier curves.

__require homebrew
case "$1" in
install)
	__brew_install imagemagick
;;
remove)
;;
esac
