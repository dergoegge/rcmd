#!/bin/sh
export RCMD_PATH=~/.rcmd
export VAGRANT_PATH=./.vagrant
export SUPPORTED_PROVIDERS=(google aws)
export PRINT_BOLD=$(tput bold)
export PRINT_NORMAL=$(tput sgr0)

# execute rcmd commands
. "$RCMD_PATH/cli/main.sh" $@

# finds the .vagrant folder by moving up through the directory path
# sets the $VAGRANT_PATH variable
# exits if no .vagrant directory or Vagrantfile is found
function set_vagrant_path() {
	if [[ -d ./.vagrant || -f ./Vagrantfile ]]; then
		mkdir -p ./.vagrant
		export VAGRANT_PATH=${PWD}/.vagrant
		return
	fi

	if [ "${PWD}" = "/" ]; then
		echo "Could not find vagrant environment. ${PWD}"
		exit
	fi
	
	cd ..

	set_vagrant_path
}

# starts the machine using vagrant up and generates the ssh config
function start_machine() {
	local provider=$VAGRANT_DEFAULT_PROVIDER
	[ -z $provider ] && provider="virtualbox"

	if [ -f $VAGRANT_PATH/rcmd_provider ]; then
		provider=$(cat $VAGRANT_PATH/rcmd_provider)
	fi

	vagrant up --provider=$provider && gen_ssh_config
}

# generates the ssh config file using vagrant ssh-config
# starts the machine if vagrant ssh-config fails
function gen_ssh_config() {
	vagrant ssh-config > $VAGRANT_PATH/rcmd_ssh_config || start_machine
}

# executes a command on the remote host
function ssh_rcmd() {
	[ -f $VAGRANT_PATH/rcmd_ssh_config ] || gen_ssh_config

	ssh -F $VAGRANT_PATH/rcmd_ssh_config \
			-o ControlMaster=auto \
			-o ControlPath=$VAGRANT_PATH/rcmd_%r@%h:%p \
			-o ControlPersist=yes \
			-o RequestTTY=yes \
			default \
			"$*"
	
	# ssh error
	# start machine and try again
	if [ "$?" = "255" ]; then
		start_machine && ssh_rcmd $@
	fi
}

set_vagrant_path
ssh_rcmd $@