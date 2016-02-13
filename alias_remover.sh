#!/bin/bash
#Script to remove alias already created

if [ $# == 1 ]
	then
	if [ $(grep "alias $1=" $HOME/.bash_aliases | wc -l) == 1 ]
		then
		unalias "$1"
		sed "/alias $1=/d" $HOME/.bash_aliases > tmp.txt
		rm $HOME/.bash_aliases
		cat tmp.txt > $HOME/.bash_aliases
		rm tmp.txt
		echo "Alias removed succesfully"
	else
		echo "Error: Alias not found"
	fi
else
	echo "Error: Sintaxis: ./alias_remover.sh <alias_name>"
fi
