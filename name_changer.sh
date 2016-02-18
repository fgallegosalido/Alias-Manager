#!/bin/bash
# Script to change the name of a defined alias

if [ $# -eq 2 ]
	then
	if [ $(cat $HOME/.bash_aliases | grep "alias $1=" | wc -l) == 1 ]
		then
		if type $2 &> /dev/null
			echo "The new name is already a command"
		else
			unalias $1
			sed -i "s/alias $1=/alias $2=/" ~/.bash_aliases
			string=$(cat $HOME/.bash_aliases | grep "alias $2=" | cut -d"=" -f2-)
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
