#!/bin/bash
#Script para crear o modificar aliases, permanentes y no repetidos

if [ $# -eq 2 ]
	then
	if [ $(cat $HOME/.bash_aliases | grep "alias $1=" | wc -l) == 0 ]
		then
		if type $1 &> $HOME/tmp.txt
			then
			echo "El alias ya es un comando"
		else
			echo "alias $1=\"$2\"" >> $HOME/.bash_aliases
			echo "Alias creado con éxito"
			alias $1="$2"
		fi
	rm $HOME/tmp.txt
	else
		echo "Ya existe un alias con ese nombre"
	fi
else
	echo 'Error: Sintáxis: addal nombre_alias "comando" (comando entre comillas dobles)'
fi
