#!/bin/bash

DEV_ROOT="$1"
SOURCES="$2"
NAME="$3"


if [ "$DEV_ROOT" == "" ]; then 
        echo "Error: the development directory is not specified.";
        exit
fi

if [ "$SOURCES" == "" ]; then 
        echo "Error: the sources directory is not specified.";
        exit
fi

if [ "$NAME" == "" ] ; then
        echo -n "class NAME: ";
        read NAME
fi 

HPP_FILE=$DEV_ROOT/$SOURCES/$NAME.hpp
echo "" > $HPP_FILE
echo -n "#ifndef " >> $HPP_FILE
echo -n $NAME|tr [a-z] [A-Z] >> $HPP_FILE
echo "_HPP" >> $HPP_FILE
echo -n "#define " >> $HPP_FILE
echo -n $NAME|tr [a-z] [A-Z] >> $HPP_FILE
echo "_HPP" >> $HPP_FILE

echo "" >> $HPP_FILE
echo "class "$NAME >> $HPP_FILE
echo "{" >> $HPP_FILE
echo "public:" >> $HPP_FILE
echo -e "\t"$NAME"();" >> $HPP_FILE
echo "};" >> $HPP_FILE
echo "" >> $HPP_FILE

CPP_FILE=$DEV_ROOT/$SOURCES/$NAME.cpp
echo "" > $CPP_FILE
echo "#include <"$NAME".hpp>" >> $CPP_FILE
echo "" >> $CPP_FILE
echo $NAME"::"$NAME"()" >> $CPP_FILE
echo "{" >> $CPP_FILE
echo "}" >> $CPP_FILE

touch $DEV_ROOT/$SOURCES/$NAME.cpp

