#!./bin/bash

BUILDER_DIR=$1
TEST_DIR=$2
DEV_ROOT=$3

if [ "$BUILDER_DIR" == "" ]; then 
        echo "Error: the builder directory is not specified.";
        exit
fi

if [ "$TEST_DIR" == "" ]; then 
        echo "Warning: the test directory is not specified.";
        echo -n "Test directory: (tst)"
        read TEST_DIR
        if [ "$TEST_DIR" == "" ]; then 
                TEST_DIR=tst
        fi
fi

TEST_TMPL=$BUILDER_DIR/templates/tester
MAIN_TMPL=$BUILDER_DIR/templates/main
TULITIES_TMPL=$BUILDER_DIR/templates/tutilities
TOP_MKF_TMPL=$BUILDER_DIR/templates/top_makefile
PROJECT_MKF_TMPL=$BUILDER_DIR/templates/project_makefile
SETTINGS_TMPL=$BUILDER_DIR/templates/settings
PROJECT_MKF=$DEV_ROOT/$TEST_DIR/simple/src/makefile
PROJECT_CREATOR=$BUILDER_DIR/wizards/project_creation.sh

if [ ! -d $TEST_DIR ]; then 
        echo "Warning: The test directory does not exist.";
        echo "TBuilder creates an empry directory.";
        mkdir $TEST_DIR
        cat $TEST_TMPL >> $TEST_DIR/tester.sh
        chmod a+x $TEST_DIR/tester.sh
fi

if [ "$name"=="" ]; then 
        echo -n "Enter test name: ";
        read name
fi 

$PROJECT_CREATOR $BUILDER_DIR $DEV_ROOT/$TEST_DIR $name

mv $PROJECT_MKF $PROJECT_MKF"_tmp"
echo "#ADDED BY WIZARD" > $PROJECT_MKF
echo "CPP_COMPILER_FLAGS += -I"$DEV_ROOT"/src" >> $PROJECT_MKF
echo "" >> $PROJECT_MKF
cat $PROJECT_MKF"_tmp" >> $PROJECT_MKF
rm $PROJECT_MKF"_tmp"
