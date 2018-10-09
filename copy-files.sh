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

get_files_properties

if [ $STATUS == 0 ]; then
	check_directory $DESTINY_DIR
fi

for V_FILE in ${FILES[@]}
do
	STATUS=0
	
	printf "\n" >> $LOG 2>&1
	logger "------------------------------"
	logger $V_FILE
	logger "------------------------------"
	
	get_info $V_FILE
	
	if [ $STATUS == 0 ]; then
		check_file $V_FILE_DIR $V_FILE_NAME
	fi

	if [ $STATUS == 0 ]; then
		copy_file $V_FILE_DIR"/"$V_FILE_NAME $DESTINY_DIR
	fi

	if [ $STATUS != 0 ]; then
		echo "ERROR: The file $V_FILE could not be copied, check the log $LOG"
	fi
done

exit 0
# FINISHED
