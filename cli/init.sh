#!/bin/sh

# create provider template
if [[ " ${SUPPORTED_PROVIDERS[@]} " =~ " $1 " ]]; then
	cp $RCMD_PATH/vagrant-templates/$1 ./Vagrantfile
	exit
fi

if [ ! $1 == "--init" ]; then
	echo "$1 is not a supported provider"
	exit
fi

# copy default environment
cp -a $RCMD_PATH/env/. ./