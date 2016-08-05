#!/bin/bash
# Script to manage permanent aliases, so you can use them as usual commands.

# This script highly relies that in your .bashrc file there's a block of bash
# code that looks exactly like this:
#
#     if [ -f ~/.bash_aliases ]; then
#        . ~/.bash_aliases
#     fi
#
# What this block does is executing the script called ".bash_aliases" (in fact
# that script is where all your "permanent" aliases are going to be defined).
#
# If that block doesn't exist in your .bashrc file, then this script is just
# useless (no aliases are defined when starting up the terminal).
#
# This script could have been done so all aliases are added to .bashrc directly
# instead of relying on the invocation of .bash_aliases, but it's better not to
# touch the file .bashrc because some things could get screwed in future shell
# sessions.
#
# If you find out that your aliases doesn't stay defined when you close and
# reopen the terminal, then you should check that the block above is inside the
# .bashrc.
#
# Anyway, by default .bashrc has that block of code inside, so there shouldn't
# be any problem (unless you messed up with the file itself).

author="Francisco Gallego Salido"
version="0.3" # Script version

# Just check if the file .bash_aliases exists in the home directory,
# and if it doesn't, initialize it with an alias to the path of this script
if [ ! -f $HOME/.bash_aliases ]; then
   echo "# DO NOT TOUCH THIS FILE UNLESS YOU'RE SURE OF WHAT YOU'RE DOING" >> $HOME/.bash_aliases
   DIR=$(echo ${BASH_SOURCE[0]} | rev | cut -d"/" -f2- | rev)
   NAME=$(echo $0 | rev | cut -d"/" -f1 | rev)
   cd $DIR
   DIR="$(pwd)/$NAME"
   echo "alias almod=\". $DIR\"" >> $HOME/.bash_aliases
   alias almod=". $DIR"
   echo "A new alias has been attached to this script path. Next executions must be done with the command 'almod'"
   echo "You may need to restart the shell to get everything working well"
   echo "------------------------------"
fi

# Function to create new alias
_new_alias(){
   if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 0 ]; then
      # Make sure we don't overwrite any other command
      if type $1 &> /dev/null; then
         echo "The alias is already a command or alias"
      else
         echo "alias $1=\"$2\"" >> $HOME/.bash_aliases
         echo "Alias created succesfully"
         alias $1="$2"
      fi
   else
      echo "The alias already exists"
   fi
}

# Function to delete an already defined alias
_delete_alias(){
   if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 1 ]; then
      unalias $1
      sed -i "/alias $1=/d" $HOME/.bash_aliases
      echo "Alias removed succesfully"
   else
      echo "Error: Alias not found"
   fi
}

# Function to change the definition of an alias
_new_definition(){
   if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 1 ]; then
      unalias $1
      sed -i "/alias $1=/d" $HOME/.bash_aliases
      echo "alias $1=\"$2\"" >> $HOME/.bash_aliases
      alias $1="$2"
      echo "Alias succesfully redefined"
   else
      echo "Error: Alias not found"
   fi
}

# Function to change the name of an alias
_new_name(){
   if [ $(egrep "^alias $1=.*" $HOME/.bash_aliases | wc -l) == 1 ]; then
      # Make sure we not overwrite any other command
      if type $2 &> /dev/null; then
         echo "The new name is already a command or alias"
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
}

# Function to print the help message
_help(){
   echo "Usage: almod [option] [rest_of_arguments]"
   echo "Options:"
   printf "\t-l, --list\n\t\tList all user-defined aliases\n"
   printf "\t-n, --new NAME \"DEFINITION\"\n\t\tDefine a new alias with name NAME and defined as \"DEFINITION\"\n"
   printf "\t-d, --delete NAME\n\t\tDelete alias with name NAME\n"
   printf "\t-r, --redefine NAME \"DEFINITION\"\n\t\tRedefine the alias with name NAME as \"DEFINITION\"\n"
   printf "\t-R, --rename NAME1 NAME2\n\t\tChange the alias of name NAME1 to NAME2\n"
   printf "\t-h, --help\n\t\tShow this help and exit\n"
   printf "\t-v, --version\n\t\tShow the program version\n"
}

# Just to avoid error messages from the shell about sourcing or not sourcing
# the script and inform the user (not an actual error).
if [ "$0" = "$BASH_SOURCE" ]; then
   echo "Warning: Script not sourced"
   echo "Instead of doing ./<script_name>, do . ./<script_name>"
   echo "You can (and should) use the command 'almod' instead of the path to the script"
   echo "------------------"

# Arguments management
# If no arguments are passed, exit with error
elif [ $# -eq 0 ]; then
   echo "Error: One option is required"
   _help
   return 1

# In general, the script checks the first argument and, depending on it,
# check how many arguments does it need and throw an error if more or less
# arguments are passed. If the first argument is wrong, print the help and
# exit the program with error.
else
   if [ "$1" == "-n" ] || [ "$1" == "--new" ]; then
      if [ $# -eq 3 ]; then
         _new_alias $2 "$3"
      else
         echo "Error: Syntax: almod [-n|--new] <alias_name> \"<alias_definition>\""
         return 1
      fi

   elif [ "$1" == "-d" ] || [ "$1" == "--delete" ]; then
      if [ $# -eq 2 ]; then
         _delete_alias $2
      else
         echo "Error: Syntax: almod [-d|--delete] <alias_name>"
         return 1
      fi

   elif [ "$1" == "-r" ] || [ "$1" == "--redefine" ]; then
      if [ $# -eq 3 ]; then
         _new_definition $2 "$3"
      else
         echo "Error: Syntax: almod [-r|--redefine] <alias_name> \"<new_definition>\""
         return 1
      fi

   elif [ "$1" == "-R" ] || [ "$1" == "--rename" ]; then
      if [ $# -eq 3 ]; then
         _new_name $2 $3
      else
         echo "Error: Syntax: almod [-R|--rename] <old_name> <new_name>"
         return 1
      fi

   elif [ "$1" == "-l" ] || [ "$1" == "--list" ]; then
      sed 's/alias //g' $HOME/.bash_aliases | tail -n +2

   elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
      _help

   elif [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
      echo "Version $version"

   else
      echo "Error: Incorrect argument"
      _help
      return 1
   fi
fi
