#!/bin/bash

BUILDER_DIR="$1"
PREFIX="$2"
NAME="$4"
TYPE="$5"

if [ -f "$3" ]; then 
        source $3
fi

if [ "$BUILDER_DIR" == "" ]; then 
        echo -e "${error_color} \
Error: the builder directory is not specified."
${reset_color}
        exit
fi

if [ "$NAME" == "" ] ; then
        echo -n -e "${message_color} \
Enter project name: ";
        read NAME
        echo -e ${reset_color}
fi 

if [ "$PREFIX" == "" ] ; then 
        PREFIX=.
fi

TYPE=cpp

if [ "$TYPE" == "" ]; then 
        echo -n -e "${message_color} \
Enter project type: (CPP|systemc)"\
${reset_color};
        read TYPE
        if [ "$TYPE" == "" ]; then 
                TYPE=cpp
        fi
fi

MAIN_TMPL=$BUILDER_DIR/templates/main
TULITIES_TMPL=$BUILDER_DIR/templates/tutilities
TOP_MKF_TMPL=$BUILDER_DIR/templates/top_makefile
PROJECT_MKF_TMPL=$BUILDER_DIR/templates/project_makefile
SETTINGS_TMPL=$BUILDER_DIR/templates/settings

if [ "$TYPE" == "systemc" ]; then 
        MAIN_TMPL=$BUILDER_DIR/templates/systemc_main
        PROJECT_MKF_TMPL=$BUILDER_DIR/templates/project_makefile_systemc
fi


mkdir -p $PREFIX/$NAME
mkdir -p $PREFIX/$NAME/src
echo "export BUILDER_ROOT="$BUILDER_DIR >> $PREFIX/$NAME/makefile
echo "" >> $PREFIX/$NAME/.settings
echo "" >> $PREFIX/$NAME/src/makefile

cat $MAIN_TMPL >> $PREFIX/$NAME/src/main.cpp
cat $TULITIES_TMPL >> $PREFIX/$NAME/src/tutilities.hpp
cat $TOP_MKF_TMPL>> $PREFIX/$NAME/makefile
cat $PROJECT_MKF_TMPL>> $PREFIX/$NAME/src/makefile
cat $SETTINGS_TMPL >> $PREFIX/$NAME/.settings

