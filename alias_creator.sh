#!/bin/bash
#Script to create or modificate aliases, permanent and non repeated

if [ $# -eq 2 ]
	then
	if [ $(cat $HOME/.bash_aliases | grep "alias $1=" | wc -l) == 0 ]
		then
		if type $1 &> /dev/null
			then
			echo "The alias is already a command"
		else
			echo "alias $1=\"$2\"" >> $HOME/.bash_aliases
			echo "Alias created succesfully"
			alias $1="$2"
		fi
	else
		echo "The alias already exists"
	fi
else
	echo 'Error: Syntax: . ./alias_creator.sh <alias_name> "command" (command in double quotes)'
fi
