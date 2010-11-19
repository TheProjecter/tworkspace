#!/bin/bash

bldblk='\e[1;30m' # Black - Bold
txtred='\e[0;31m'
txtrst='\e[0m'    # Text Reset
txtblu='\e[0;34m' # Blue
bldgrn='\e[1;32m' # Green

if [ -d "$1" ]; then 
        echo -n -e " ${bldblk}> cleaning object files...${txtrst}"
        rm -fr $1
        echo -e "${bldgrn}done.${txtrst}"
fi

if [ -d "$2" ]; then 
        echo -n -e " ${bldblk}> cleaning executables...${txtrst}"
        rm -fr $2
        echo -e "${bldgrn}done.${txtrst}"
fi

if [ -f "$3/run" ]; then 
        echo -n -e " ${bldblk}> cleaning generated scripts...${txtrst}"
        rm -f $3/run
        echo -e "${bldgrn}done.${txtrst}"
fi

