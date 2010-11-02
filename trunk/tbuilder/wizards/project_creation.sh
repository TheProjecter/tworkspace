#!/bin/bash

BUILDER_DIR="$1"
PREFIX="$2"
NAME="$3"
TYPE="$4"

if [ "$BUILDER_DIR" == "" ]; then 
        echo "Error: the builder directory is not specified.";
        exit
fi

if [ "$NAME" == "" ] ; then
        echo -n "Project NAME: ";
        read NAME
fi 

if [ "$PREFIX" == "" ] ; then 
        PREFIX=.
fi

if [ "$TYPE" == "" ]; then 
        echo -n "Project TYPE: ";
        read TYPE
        if [ "$TYPE" == "sysc" ]; then 
                $BUILDER_DIR/wizards/project_creation_sysc.sh $1 $2 $NAME
                exit
        fi
fi

mkdir $NAME
echo "export BUILDER_ROOT="$BUILDER_DIR >> $PREFIX/$NAME/makefile
echo "" >> $PREFIX/$NAME/.settings
mkdir $NAME/src
echo "" >> $PREFIX/$NAME/src/makefile
cat $BUILDER_DIR/templates/main.cpp >> $PREFIX/$NAME/src/main.cpp
cat $BUILDER_DIR/templates/top_makefile >> $PREFIX/$NAME/makefile
cat $BUILDER_DIR/templates/project_makefile >> $PREFIX/$NAME/src/makefile
cat $BUILDER_DIR/templates/settings >> $PREFIX/$NAME/.settings


