cat << EOF
Prefix any command with ${PRINT_BOLD}rcmd${PRINT_NORMAL} to excecute
it in a remote virtual environment.

Use ${PRINT_BOLD}--configure${PRINT_NORMAL} to configure your default provider
	rcmd --configure <provider>

Use ${PRINT_BOLD}--init${PRINT_NORMAL} to copy your default environment
	rcmd --init
or create a new environment from a provider template
	rcmd --init <provider>

Use ${PRINT_BOLD}--help${PRINT_NORMAL} to print this help message
EOF
