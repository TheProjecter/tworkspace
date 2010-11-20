#!/bin/bash

if [ "$1" != "" ]; then 
        source $1
fi

if [ "$2" == "message" ]; then 
        echo -e ${message_color}$3${reset_color}
fi

if [ "$2" == "message_done" ]; then 
        echo -e -n ${message_color}$3${reset_color}
fi

if [ "$2" == "done" ]; then 
        echo -e ${done_color} done ${reset_color}
fi

if [ "$2" == "warning" ]; then 
        echo -e ${warning_color}$3${reset_color}
fi

