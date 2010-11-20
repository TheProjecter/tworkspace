#!/bin/bash

DEV_ROOT="$1"
SOURCES="$2"
NAME="$4"

if [ "$3" != "" ]; then 
        source $3
fi

if [ "$DEV_ROOT" == "" ]; then 
        echo -e "$error_color \
Error: the development directory is not specified.\
$reset_color";
        exit
fi

if [ "$SOURCES" == "" ]; then 
        echo -e "$error_color \
Error: the sources directory is not specified.\
$reset_color";
        exit
fi

if [ "$NAME" == "" ] ; then
        echo -n -e "$message_color \
class NAME: ";
        read NAME
        echo -e $reset_color
fi 

HPP_FILE=$DEV_ROOT/$SOURCES/$NAME.hpp
echo "" > $HPP_FILE
echo -n "#ifndef " >> $HPP_FILE
echo -n $NAME|tr [:lower:] [:upper:] >> $HPP_FILE
echo "_HPP" >> $HPP_FILE
echo -n "#define " >> $HPP_FILE
echo -n $NAME|tr [:lower:] [:upper:] >> $HPP_FILE
echo "_HPP" >> $HPP_FILE

echo "" >> $HPP_FILE
echo "class "$NAME >> $HPP_FILE
echo "{" >> $HPP_FILE
echo "public:" >> $HPP_FILE
echo -e "\t"$NAME"();" >> $HPP_FILE
echo "};" >> $HPP_FILE
echo "" >> $HPP_FILE

echo -n "#endif //" >> $HPP_FILE
echo -n $NAME|tr [:lower:] [:upper:] >> $HPP_FILE
echo "_HPP" >> $HPP_FILE

CPP_FILE=$DEV_ROOT/$SOURCES/$NAME.cpp
echo "" > $CPP_FILE
echo "#include <"$NAME".hpp>" >> $CPP_FILE
echo "" >> $CPP_FILE
echo $NAME"::"$NAME"()" >> $CPP_FILE
echo "{" >> $CPP_FILE
echo "}" >> $CPP_FILE

MAKEFILE=$DEV_ROOT/$SOURCES/makefile
mv $MAKEFILE $MAKEFILE"_tmp"
echo "#ADDED BY WIZARD" > $MAKEFILE
echo "CPP_FILES += "$NAME".cpp" >> $MAKEFILE
echo "" >> $MAKEFILE
cat $MAKEFILE"_tmp" >> $MAKEFILE

touch $DEV_ROOT/$SOURCES/$NAME.cpp

