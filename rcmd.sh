#!/bin/bash

export RCMD_PATH=~/.rcmd
export LOCAL_RCMD_PATH=${PWD}/.rcmd
export SUPPORTED_PROVIDERS=(google aws)
export PRINT_BOLD=$(tput bold)
export PRINT_NORMAL=$(tput sgr0)

# use default ~/.rcmd/env/Vagrantfile if ./Vagrantfile does not exist.
if [ ! -f ./Vagrantfile ]; then
	export VAGRANT_CWD="$RCMD_PATH/env/"
	export LOCAL_RCMD_PATH="$RCMD_PATH/env/.rcmd"
fi

# make sure $LOCAL_RCMD_PATH exists
if [ ! -d $LOCAL_RCMD_PATH ]; then 
	mkdir $LOCAL_RCMD_PATH
fi

# cli definitions
if [ $# -eq 0 ] || [ "$1" == "--help" ] ; then
	. "$RCMD_PATH/cli/help.sh" ${@:2}
	exit
fi

if [ "$1" == "--configure" ] ; then
	. "$RCMD_PATH/cli/configure/configure.sh" ${@:2}
	exit
fi

if [ "$1" == "--init" ] ; then
	. "$RCMD_PATH/cli/init.sh" ${@:2}
	exit
fi

# local vars
PROVIDER=$VAGRANT_DEFAULT_PROVIDER
CMD_TIMESTAMP="$(date "+%s")"
TMUX_SESSION="rcmd-session-$CMD_TIMESTAMP"

# local functions

# print lines between start-$CMD_TIMESTAMP and end-$CMD_TIMESTAMP
# return if end-$CMD_TIMESTAMP is seen
function print_log() {
	SAW_START=false
	while IFS= read -r LOG_LINE || [[ -n "$LOG_LINE" ]]; do
		if echo "$LOG_LINE" | grep -q "^end-$CMD_TIMESTAMP"; then
			return
		fi

		if echo "$LOG_LINE" | grep -q "^start-$CMD_TIMESTAMP"; then 
			SAW_START=true
			continue
		fi

		if [[ "$SAW_START" = true ]]; then
			echo "$LOG_LINE"
		fi
	done
}

# use configured provider if set
if [ -f $LOCAL_RCMD_PATH/provider ]; then
	PROVIDER=$(cat $LOCAL_RCMD_PATH/provider)
fi

if [ -f $LOCAL_RCMD_PATH/tmux-session ]; then
	TMUX_SESSION=$(cat $LOCAL_RCMD_PATH/tmux-session)
fi

# create tmux-session if it does not exist 
tmux has-session -t $TMUX_SESSION
if [ ! $? -eq 0 ]; then
	echo $TMUX_SESSION > $LOCAL_RCMD_PATH/tmux-session
	tmux new -d -s $TMUX_SESSION

	echo "Creating new session. This may take a while."

	tmux send -t $TMUX_SESSION "vagrant up --provider=$PROVIDER && vagrant ssh" ENTER
fi

# create log directory if it doesnt exist
if [ ! -d "$LOCAL_RCMD_PATH/logs" ]; then
	mkdir -p "$LOCAL_RCMD_PATH/logs"
fi

# create log file
LOG_FILE="$LOCAL_RCMD_PATH/logs/$CMD_TIMESTAMP.log"
touch $LOG_FILE

# pipe session output to $LOG_FILE
tmux pipe-pane -O -t $TMUX_SESSION "cat >> $LOG_FILE"

# send command to tmux session
# print $CMD_TIMESTAMP
tmux send -t $TMUX_SESSION "printf 'start-%s\n' $CMD_TIMESTAMP; $*; printf 'end-%s\n' $CMD_TIMESTAMP" ENTER 

# tail $LOG_FILE from the second line
# quit if $CMD_TIMESTAMP is seen in stdout
print_log < <(tail -f $LOG_FILE)

# close pipe
tmux pipe-pane -O -t $TMUX_SESSION