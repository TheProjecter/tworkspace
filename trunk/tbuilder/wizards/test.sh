#!./bin/bash

BUILDER_DIR=$1
DEV_ROOT=$2
COLORS=$3


if [ "$COLORS" != "" ]; then 
        source $COLORS
        warning_color=${txtblu}
        error_color=${txtred}
        message_color=${bldblk}
        reset_color=${txtrst}
fi

if [ "$BUILDER_DIR" == "" ]; then 
        echo -e "$error_color \
Error: the builder directory is not specified.\
                $reset_color";
        exit
fi

TEST_TMPL=$BUILDER_DIR/templates/tester
MAIN_TMPL=$BUILDER_DIR/templates/main
TULITIES_TMPL=$BUILDER_DIR/templates/tutilities
TOP_MKF_TMPL=$BUILDER_DIR/templates/top_makefile
PROJECT_MKF_TMPL=$BUILDER_DIR/templates/project_makefile
SETTINGS_TMPL=$BUILDER_DIR/templates/settings
PROJECT_CREATOR=$BUILDER_DIR/wizards/project_creation.sh

if [ ! -d $TEST_DIR ]; then 
        echo -e "$warning_color \
TBuilder created tst directory under Your project root. \
                $reset_color";
        mkdir $TEST_DIR
        cat $TEST_TMPL >> $TEST_DIR/tester.sh
        chmod a+x $TEST_DIR/tester.sh
fi

if [ "$name"=="" ]; then 
        echo -n -e "$message_color \
Enter test name: ";
        read name
        echo -e "$reset_color";
fi 

PROJECT_MKF=$DEV_ROOT/$TEST_DIR/$name/src/makefile
$PROJECT_CREATOR $BUILDER_DIR $DEV_ROOT/$TEST_DIR $name

mv $PROJECT_MKF $PROJECT_MKF"_tmp"
echo "#ADDED BY WIZARD" > $PROJECT_MKF
echo "CPP_COMPILER_FLAGS += -I"$DEV_ROOT"/src" >> $PROJECT_MKF
echo "" >> $PROJECT_MKF
cat $PROJECT_MKF"_tmp" >> $PROJECT_MKF
rm $PROJECT_MKF"_tmp"
