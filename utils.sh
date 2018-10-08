#! /bin/bash
## utils by @palomaclaud
## Paloma Claudino <paloma.claud@gmail.com>

function parameter_check() {
	V_PARAMETERS=$1
	V_QTY_PAR=$2
	V_DESC_PAR=$3
	V_FUNCTION_NAME=$4
	
	if [ $V_PARAMETERS -ne $V_QTY_PAR ]; then
		logger "ERROR: You must enter $V_QTY_PAR ($V_DESC_PAR) parameter(s) to execute the $V_FUNCTION_NAME function"
		STATUS=1
		exit 126
	fi	
}

## logger function
function logger() {
	parameter_check $# 1 "1=MESSAGE" "logger"
	
	LOG_MSG=$1
	LOG_DATE=`date '+%Y-%m-%d %H:%M:%S'`
	
	printf "\n[$LOG_DATE]\t$LOG_MSG" >> $LOG 2>&1
}

## create a new directory
function create_diretory() {
	logger "Creating directory"	
	parameter_check $# 1 "1=DIRECTORY" "create_diretory"
	
	DIR=$1
	logger "\tDIR = ${DIR}"

	if mkdir -p $DIR ; then
		logger "Successfully created directory!"
	else
		logger "ERROR: Could not create directory $DIR"
		STATUS=1
	fi
}

## check existence of a directory and create if it doest already exist
function check_directory() {
	logger "Checking directory existence"	
	parameter_check $# 1 "1=DIRECTORY" "check_directory"
	
	DIR=$1
	logger "\tDIR = ${DIR}"

	if [ -d "$DIR" ] ; then
		logger "Existing directory"
	else
		logger "ALERT: Non-existent directory $DIR"
		create_diretory $DIR
	fi	
}

## check existence of a file
function check_file() {
	logger "Checking file existence"	
	parameter_check $# 2 "1=DIRECTORY 2=FILE" "check_file"
	
	DIR=$1
	FILE=$2
	logger "\tDIR = ${DIR}"
	logger "\tFILE = ${FILE}"

	if [ -f "$DIR/$FILE" ] ; then
		logger "Existing file"
	else
		logger "ERROR: Non-existent file $DIR/$FILE"
		STATUS=1
	fi	
}

## copy of files
function copy_file() {
	logger "Copying file"	
	parameter_check $# 2 "1=SOURCE DIRECTORY 2=DESTINATION DIRECTORY" "copy_file"
	
	SOURCE=$1
	DESTINY=$2
	logger "\tSOURCE = ${SOURCE}"
	logger "\tDESTINY = ${DESTINY}"
	
	chmod 777 $SOURCE 2>> $LOG
	cp -r $SOURCE $DESTINY 2>> $LOG
	if [ $? -eq 0 ] ; then
		logger "File $SOURCE successfully copied to $DESTINY"
	else
		logger "ERROR: Could not copy the file $SOURCE to $DESTINY"
		STATUS=1
	fi
}
