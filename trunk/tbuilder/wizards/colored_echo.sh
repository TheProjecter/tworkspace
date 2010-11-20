#!/bin/bash

if [ "$1" != "" ]; then 
        source $1
        warning_color=${txtblu}
        error_color=${txtred}
        message_color=${bldblk}
        done_color=${undwht}${badgrn}
        reset_color=${txtrst}
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

