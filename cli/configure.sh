#!/bin/sh

# saves the provider supplied as the first parameter in
# the directory supplied as second parameter
function save_provider() {
	echo $1 > $2/rcmd_provider
}

# configures the provider supplied as the first parameter in ./
# asks the user for permission to overwrite the current Vagrantfile
function configure_provider() {
	check_provider $1 || return 1

	vagrant plugin install vagrant-$1
	
	if [ ! -d ./.vagrant ]; then
		mkdir ./.vagrant
	fi

	save_provider $1 ./.vagrant

	if [ -f ./Vagrantfile ]; then
		read -r -p "Do you want to overwrite your current Vagrantfile? [y/N] " response
		case "$response" in
    [yY][eE][sS]|[yY]) 
				copy_vagrant_template $1
        ;;
		esac
	else
		copy_vagrant_template $1
	fi

	echo "Configured $1 as provider."
}

# configures the rcmd default environment
function configure_default_env() {
	local env_path=$RCMD_PATH/env

	if [ ! -d env_path ]; then
		mkdir env_path
	fi

	cd env_path

	configure_provider $1 && \
		echo "Configured default environment with $1 as provider."
}

if [ $1 == "provider" ] ; then
	configure_provider ${@:2}; exit
fi

if [ $1 == "default-env" ] ; then
	configure_default_env ${@:2}; exit
fi

echo "Unknown configuration: $1"