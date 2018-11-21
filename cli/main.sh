help_msg="Prefix any command with ${PRINT_BOLD}rcmd${PRINT_NORMAL} to excecute
it in a remote virtual environment.

Use ${PRINT_BOLD}--configure${PRINT_NORMAL} to configure your default provider
	rcmd --configure <provider>

Use ${PRINT_BOLD}--init${PRINT_NORMAL} to copy your default environment
	rcmd --init
or create a new environment from a provider template
	rcmd --init <provider>

Use ${PRINT_BOLD}--help${PRINT_NORMAL} to print this help message"

# checks if the provider supplied as the first parameter is supported
function check_provider() {
	if [[ ! " ${SUPPORTED_PROVIDERS[@]} " =~ " $1 " ]]; then
		echo "$1 is not a supported provider"
		return 1
	fi

	return 0
}

# copy a Vagrantfile template for the provider supplied as the first parameter
function copy_vagrant_template() {
	cp $RCMD_PATH/vagrant-templates/$1 ./Vagrantfile
	echo "Copied Vagrantfile for the $1 provider"
}

# copies the default environment to ./
function copy_default_env() {
	cp -a $RCMD_PATH/env/. ./
	echo "Copied default environement"
}

# inits a vagrant env in ./
# if a provider is supplied it copies the corresponding Vagrantfile template to ./
# if not it copies the rcmd default env to ./
function init_env() {
	(check_provider $@ > /dev/null && copy_vagrant_template $@) || copy_default_env
}

export -f check_provider
export -f copy_vagrant_template

if [ $# -eq 0 ] || [ $1 == "--help" ] ; then
	echo "$help_msg"; exit
fi

if [ $1 == "--init" ] ; then
	init_env ${@:2}; exit
fi

if [ $1 == "--configure" ] ; then
	. "$RCMD_PATH/cli/configure.sh" ${@:2}
	exit
fi