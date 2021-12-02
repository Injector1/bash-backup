#!/bin/bash

# VARIABLES
INPUT_DIRECTORY=$1
EXT=$2
OUTPUT_DIRECTORY=$3
COPYING=$4
DEPTH=$5
DIR=`pwd`
CRON_JOB="* * * * * $(pwd)/backup.sh $INPUT_DIRECTORY $EXT $OUTPUT_DIRECTORY"
filenames=`cd && find ${INPUT_DIRECTORY} -maxdepth 1 -name "*.${EXT}"`

# FUNCTIONS
zipFiles() {
    for file in $filenames
    do
        echo $file
        if [[ -f "backup.zip" ]]
        then
            zip -rv -j $OUTPUT_DIRECTORY/backup.zip $file
        else
            zip -j $OUTPUT_DIRECTORY/backup.zip $file
        fi
    done
    
    echo -e "\e[32m[SUCCEED]: Successfully archived\e[0m"
}

planJob() {
    if [ ! -z $COPYING ]
    then
        crontab -l | { cat; echo "$CRON_JOB"; } | crontab -
        echo -e "\e[32m[SUCCEED]: Successfully planned job\e[0m"
    else
        echo -e "\e[33m[WARNING]: If you want to make this script executable - give the fourth argument to function\e[0m"
    fi
}

# EXECUTING FUNCTIONS
zipFiles $filenames
planJob $COPYING