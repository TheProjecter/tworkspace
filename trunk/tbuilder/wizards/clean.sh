#!/bin/bash

if [ "$4" != "" ]; then 
        source $4
fi

if [ -d "$1" ]; then 
        echo -n -e "$message_color \
cleaning object files...\
$reset_color"
        rm -fr $1
        echo -e "$done_color\
 done \
$reset_color"
fi

if [ -d "$2" ]; then 
        echo -n -e "$message_color \
cleaning executables... \
$reset_color"
        rm -fr $2
        echo -e "$done_color\
 done \
$reset_color"
fi

if [ -f "$3/run" ]; then 
        echo -n -e "$message_color \
cleaning generated scripts... \
$reset_color"
        rm -f $3/run
        echo -e "$done_color\
 done \
$reset_color"
fi

