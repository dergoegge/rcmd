PRINT_BOLD=$(tput bold)
PRINT_NORMAL=$(tput sgr0)
RCMD_PATH=~/.rcmd

if [ -d $RCMD_PATH ]; then
	echo "rcmd is already installed"
	exit
fi

git clone https://github.com/dergoegge/rcmd.git $RCMD_PATH

ln -s $RCMD_PATH/rcmd.sh $RCMD_PATH/rcmd

PATH_='$PATH'
cat << EOF
To use rcmd add it to your path variable:

${PRINT_BOLD}export PATH=$PATH_:~/.rcmd/rcmd${PRINT_NORMAL}
EOF