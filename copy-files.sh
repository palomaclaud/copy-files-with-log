#! /bin/bash
## copy-files by @palomaclaud
## Paloma Claudino <paloma.claud@gmail.com>

## INSTRUCTIONS:
## Run on current git repository with $ sh ./copy-files.sh

. utils.sh

## Log file
LOG_DIR=log
LOG_FILE=$(basename $0).$$.log
LOG=$LOG_DIR"/"$LOG_FILE

check_directory $LOG_DIR

touch $LOG 2>> $LOG
chmod 777 $LOG 2>> $LOG

## START COPY-FILES SHELL SCRIPT
clear
printf "\n\n### LOG SCRIPT $(basename $0)\n" >> $LOG 2>&1

STATUS=0

SOURCE_DIR=example_dir
SOURCE_FILE=example_file.txt

DESTINY_DIR=test_dest


if [ $STATUS == 0 ]; then
	check_file $SOURCE_DIR $SOURCE_FILE
fi

if [ $STATUS == 0 ]; then
	check_directory $DESTINY_DIR
fi

echo $STATUS

if [ $STATUS == 0 ]; then
	copy_file $SOURCE_DIR"/"$SOURCE_FILE $DESTINY_DIR
fi

if [ $STATUS != 0 ]; then
	echo "ERROR: The files could not be copied, check the log $LOG"
fi

exit 0
# FINISHED
