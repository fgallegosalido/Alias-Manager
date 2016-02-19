#!/bin/bash
# Script to change the name of a defined alias

if [ $# -eq 2 ]
	then
	if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 1 ]
		then
		if type $2 &> /dev/null
			then
			echo "The new name is already a command"
		else
			unalias $1
			sed -i "s/alias $1=/alias $2=/" ~/.bash_aliases
			string=$(egrep "^alias $2=.*" $HOME/.bash_aliases | cut -d"=" -f2-)
			string=${string:1:-1}
			alias $2="$string"
			echo "Alias name changed succesfully"
		fi
	else
		echo "Error: Alias not found"
	fi
else
	echo 'Error: Syntax: . ./name_changer.sh <old_name> <new_name>'
fi
