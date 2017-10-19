#!/bin/bash

top_dir=$(cd $(dirname $0) && pwd)

cd $top_dir
source error.sh

PATH="$PATH:$(pwd)/tools/cc65/bin"
cc65 --version &> /dev/null || error_exit "Could not get cc65 version"

cl65 -t nes \
	examples/nes-gamedev-examples/part01/ex01-c-example/hello-nes.c \
	-o examples/nes-gamedev-examples/part01/ex01-c-example/hello.nes

if [ ! -f "examples/nes-gamedev-examples/part01/ex01-c-example/hello.nes" ] ;
then
	error_exit "Build result not found"
fi
