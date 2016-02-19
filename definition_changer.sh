#!/bin/bash
# Script to change the definition of a defined alias

if [ $# -eq 2 ]
  then
  if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 1 ]
    then
    unalias $1
    sed -i "/alias $1=/d" $HOME/.bash_aliases
    echo "alias $1=\"$2\"" >> $HOME/.bash_aliases
    alias $1="$2"
    echo "Alias succesfully redefined"
  else
    echo "Error: Alias not found"
  fi
else
  echo 'Error: Syntax: . ./definition_changer.sh <alias_name> "new_command" (command in double quotes)'
fi
