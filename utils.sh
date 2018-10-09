#! /bin/bash
## utils by @palomaclaud
## Paloma Claudino <paloma.claud@gmail.com>

function parameter_check() {
	PARAMETERS=$1
	QTY_PAR=$2
	DESC_PAR=$3
	FUNCTION_NAME=$4
	
	if [ $PARAMETERS -ne $QTY_PAR ]; then
		logger "ERROR: You must enter $QTY_PAR ($DESC_PAR) parameter(s) to execute the $FUNCTION_NAME function"
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

function get_files_properties() {
	logger "Getting files properties"
	
	FILES=$( grep -si "^files=" files.properties | sed -n 's/[^=]*=//p' )
	DESTINY_DIR=$( grep -si "^destiny_dir=" files.properties | sed -n 's/[^=]*=//p' )	
	logger "\tFILES = ${FILES}"
	logger "\tDESTINY_DIR = ${DESTINY_DIR}"
	
	if [ "$FILES" == "" ] || [ "$DESTINY_DIR" == "" ] ; then
		logger "ERROR: Incorrectly configured properties file"
		STATUS=1
	else
		logger "Properties get successfully"
	fi	
}

function get_info() {
	logger "Getting file info"
	parameter_check $# 1 "1=FILE" "get_info"
	
	V_FILE=$1
	logger "\tV_FILE = ${V_FILE}"
	
	V_FILE_DIR=$( grep -si "^$V_FILE.dir=" files.properties | sed -n 's/[^=]*=//p' )
	V_FILE_NAME=$( grep -si "^$V_FILE.file=" files.properties | sed -n 's/[^=]*=//p' )
	logger "\tV_FILE_DIR = $V_FILE_DIR"
	logger "\tV_FILE_NAME = $V_FILE_NAME"
	
	if [ "$V_FILE_DIR" == "" ] || [ "$V_FILE_NAME" == "" ] ; then
		logger "ERROR: Incorrectly configured properties file"
		STATUS=1
	else
		logger "Information get successfully"
	fi	
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
		logger "Directory already exists"
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
