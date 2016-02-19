# Alias-Manager
A script in bash that will help you create your own commands (Still work in progress)

Every script (by the moment) must be executed the following way in order to work properly:

``` bash
$> . /path/to/script/<script_name>  #This keeps everything updated in the current sesion
```

Instead of

``` bash
$> /path/to/script/<script_name>    #This way won't update your current aliases, but will add them to the file
```

This is due to the way shell scripts are executed.
