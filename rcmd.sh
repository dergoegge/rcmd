#!/bin/sh
export RCMD_PATH=~/.rcmd
export SUPPORTED_PROVIDERS=(google aws)

export PRINT_BOLD=$(tput bold)
export PRINT_NORMAL=$(tput sgr0)

if [ $# -eq 0 ] || [ $1 == "--help" ] ; then
	. "$RCMD_PATH/cli/help.sh" ${@:2}
	exit
fi

if [ $1 == "--configure" ] ; then
	. "$RCMD_PATH/cli/configure/configure.sh" ${@:2}
	exit
fi

if [ $1 == "--init" ] ; then
	. "$RCMD_PATH/cli/init.sh" ${@:2}
	exit
fi

PROVIDER=$VAGRANT_DEFAULT_PROVIDER

# use configured provider if set
if [ -f $RCMD_PATH/provider ]; then
	PROVIDER=$(cat $RCMD_PATH/provider)
fi

# use default ~/.rcmd/env/Vagrantfile if ./Vagrantfile does not exist.
if [ ! -f ./Vagrantfile ]; then
	export VAGRANT_CWD="$RCMD_PATH/env/"
fi

vagrant up --provider=$PROVIDER
vagrant ssh --command "$*"