#!/bin/sh

if [ $1 == "provider" ] ; then
	. "$RCMD_PATH/cli/configure/providers.sh" ${@:2}
	exit
fi

# more configurations here

echo "unknown command: $1"