#!/bin/sh

# check provider support
if [[ ! " ${SUPPORTED_PROVIDERS[@]} " =~ " $1 " ]]; then
	echo "$1 is not a supported provider"
	exit
fi

# install provider plugin
vagrant plugin install vagrant-$1

# save chosen provider
echo $1 > $LOCAL_RCMD_PATH/provider

# if ~/.rcmd/env/Vagrantfile already exists rename it to Vagrantfile_%timestamp%
if [ -f $RCMD_PATH/env/Vagrantfile ]; then
	TIMESTAMP=$(date "+%s")
	STAMPED_FILE="$RCMD_PATH/env/Vagrantfile_$TIMESTAMP"
	mv $RCMD_PATH/env/Vagrantfile $STAMPED_FILE

	echo "moved old default Vagrantfile to $STAMPED_FILE"
fi

# copy provider template to ~/.rcmd/env
if [ ! -d $RCMD_PATH/env/ ]; then
	mkdir $RCMD_PATH/env/ 
fi

cp $RCMD_PATH/vagrant-templates/$1 $RCMD_PATH/env/Vagrantfile

# print instructions
cat << EOF

Your default environment has been setup but you 
will need to edit it with your $1 info.
EOF