#!/bin/bash

# first autocomplete commands then files and dirs
# TODO: find a way to forward autocompletion from remote machine
_rcmd_completions() {
	if [ ${#COMP_WORDS[@]} -gt 1 ]; then 
	  COMPREPLY=($(rcmd compgen -df "${COMP_WORDS[${#COMP_WORDS[@]}]}"))
		return
	fi

  COMPREPLY=(compgen -W $(rcmd compgen -c "${COMP_WORDS[${#COMP_WORDS[@]}]}") )
}

complete -F _rcmd_completions rcmd