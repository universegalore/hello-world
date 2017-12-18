#!/usr/bin/env bash

name="$(basename $1)"

echo "$name"

convert "$1"  \( +clone -background "black" -shadow "5%5x3+0+2" \) +swap -background "transparent" -layers merge +repage "/home/eldou/Pictures/Screenshots/shadow/shadow_$name"