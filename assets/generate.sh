#!/usr/bin/env bash

function resize {
    file=$1

    for size in 70 90 300; do
	convert $1.xcf -resize "${size}x${size}" $1_$size.png
    done
}

resize red_cross
resize green_check
resize question_mark
