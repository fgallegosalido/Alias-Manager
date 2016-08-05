# Alias-Manager
## Basic Information
A script in bash that will help you create your own commands (Beta).

This script highly relies that in your .bashrc file there's a block of bash
code that looks exactly like this:

```bash
   if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
   fi
```

What this block does is executing the script called ".bash_aliases" (in fact
that script is where all your "permanent" aliases are going to be defined).

If that block doesn't exist in your .bashrc file, then this script is just
useless (no aliases are defined when starting up the terminal).

This script could have been done so all aliases are added to .bashrc directly
instead of relying on the invocation of .bash_aliases, but it's better not to
touch the file .bashrc because some things could get screwed in future shell
sessions.

If you find out that your aliases doesn't stay defined when you close and
reopen the terminal, then you should check that the block above is inside the
.bashrc.

Anyway, by default .bashrc has that block of code inside, so there shouldn't
be any problem (unless you messed up with the file itself).

## First execution
The firs time the script is executed, it checks if the file .bash_aliases exists
in your home directory. If it doesn't, creates one and initialize it with an
alias to the path of the script called "almod".

You may need to restart the shell to get everything working well.

Note: You'd better source the script, like this:

```bash
$> . /path/to/script/<script_name> ...
```

Instead of,

```bash
$> /path/to/script/script_name> ...
```

This way, fewer problems will appear.
