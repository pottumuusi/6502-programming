#!/bin/bash

top_dir=$(cd $(dirname $0) && pwd)

distribution_dependent_setup() {
		is_arch="n"
		is_ubuntu="n"

		if [ "ARCH" == "$(uname -r | grep -o ARCH)" ] ; then
			is_arch="y"
		fi

		if [ "Ubuntu" == "$(lsb_release -i 2> /dev/null | grep -o Ubuntu)" ] ;
		then
			is_ubuntu="y"
		fi

		if [ "y" == "$is_ubuntu" -a "y" == "$is_arch" ] ; then
			echo "Detected to be ubuntu and arch at the same time"
			error_exit "Distribution detection failed"
		fi

		if [ "y" == $is_arch ] ; then
			arch_setup
			return
		fi

		if [ "y" == $is_ubuntu ] ; then
			ubuntu_setup
			return
		fi

		error_exit "Distribution detection failed"
}

arch_setup() {
		echo "Installing dependencies next"

		if [ -z "$(which fceux 2> /dev/null)" ] ; then
				sudo pacman -S fceux || error_exit "Failed to install fceux"
		fi

		if [ -z "$(which git 2> /dev/null)" ] ; then
				sudo pacman -S git || error_exit "Failed to install git"
		fi

		if [ -z "$(which curl 2> /dev/null)" ] ; then
				sudo pacman -S curl || error_exit "Failed to install curl"
		fi

		if [ -z "$(which unzip 2> /dev/null)" ] ; then
				sudo pacman -S unzip || error_exit "Failed to install unzip"
		fi
}

ubuntu_setup() {
		echo "Installing dependencies next"

		if [ -z "$(which fceux 2> /dev/null)" ] ; then
				sudo apt-get install fceux \
					|| error_exit "Failed to install fceux"
		fi

		if [ -z "$(which git 2> /dev/null)" ] ; then
				sudo apt-get install git || error_exit "Failed to install git"
		fi

		if [ -z "$(which curl 2> /dev/null)" ] ; then
				sudo apt-get install curl \
					|| error_exit "Failed to install curl"
		fi

		if [ -z "$(which unzip 2> /dev/null)" ] ; then
				sudo apt-get install unzip \
					|| error_exit "Failed to install unzip"
		fi
}

do_distribution_dependent_setup="y"

cd $top_dir
source error.sh

if [ "y" == "$do_distribution_dependent_setup" ] ; then
		distribution_dependent_setup
fi

if [ ! -d "tools" ] ; then
	mkdir tools
fi

cd tools
if [ ! -d "cc65" ] ; then
		git clone https://github.com/cc65/cc65 \
			|| error_exit "Failed to clone cc65 repo"
fi

cd $top_dir
if [ ! -d "examples/bombsweeper" ] ; then
		mkdir -p examples/bombsweeper
fi

cd examples/bombsweeper
if [ ! -f "BombSweeper.nes" ] ; then
		curl -Lo bombsweeper.zip http://www.zophar.net/download_file/11839 \
			|| error_exit "Failed to download bombsweeper"
		unzip bombsweeper.zip
fi

cd ..
if [ ! -d "nes-gamedev-examples" ] ; then
		echo "cloning  nesgamedevexamples"
		git clone https://github.com/algofoogle/nes-gamedev-examples.git \
			|| error_exit "Failed to clone nes-gamedev-examples"

		# In example 'waitvblank' function is used. This was most likely
		# correct at the time of making the example.
		# It seems that at the moment 'waitvblank' is called 'waitvsync'.
		sed -i 's/waitvblank/waitvsync/g' \
			nes-gamedev-examples/part01/ex01-c-example/hello-nes.c
fi

cd $top_dir
cd tools/cc65 || error_exit "Could not cd to tools/cc65"
make || error_exit "Failed to build cc65"
bin/cc65 --version || error_exit "Could not get cc65 version"
