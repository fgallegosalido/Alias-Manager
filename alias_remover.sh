#!/bin/bash
#Script para borrar aliases ya definidos

if [ $# == 1 ]
	then
	if [ $(grep "alias $1=" $HOME/.bash_aliases | wc -l) == 1 ]
		then
		unalias "$1"
		sed "/alias $1=/d" $HOME/.bash_aliases > tmp.txt
		rm $HOME/.bash_aliases
		cat tmp.txt > $HOME/.bash_aliases
		rm tmp.txt
		echo "Alias borrado con éxito"
	else
		echo "No existe el alias indicado"
	fi
else
	echo "Error: Sintaxis: rmal nombre_alias"
fi
