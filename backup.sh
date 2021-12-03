#!/bin/bash

# VARIABLES
INPUT_DIRECTORY=$1
EXT=$2
OUTPUT_DIRECTORY=$3
REPETITIONS=$4
DEPTH=$5

# FUNCTIONS
zipFiles() {
    for file in $filenames
    do
        if [[ -f "$backup_name.zip" ]]
        then
            zip -rv -j "$OUTPUT_DIRECTORY"/"$backup_name".zip "$file"
        else
            zip -j "$OUTPUT_DIRECTORY"/"$backup_name".zip "$file"
        fi
    done
    
    echo -e "\e[32m[SUCCEED]: Successfully archived to $backup_name.zip\e[0m"
}

planJob() {
    if [[ -n $REPETITIONS && ! $REPETITIONS = "none"  && ${#REPETITIONS} -gt 8 ]]
    then
        crontab -l | { cat; echo "$CRON_JOB"; } | crontab -
        echo -e "\e[32m[SUCCEED]: Successfully planned job\e[0m"
    else
        echo -e "\e[33m[WARNING]: If you want to make this script executable - give the [REPETITIONS] argument to function (type './backup.sh -h' for more info)\e[0m"
    fi
}

checkSum() {
    sha1sum "$filenames" > "$OUTPUT_DIRECTORY"/"$backup_name".sha1
}

deleteOldBackups() {
    backups=$(ll "$OUTPUT_DIRECTORY" -tr --full-time | grep "backup-.*.zip$" | awk '{print echo $9}')
    backups_count=$(ll "$OUTPUT_DIRECTORY" -t | grep 'backup-.*\.zip$' -c)
    if [[ $backups_count > $DEPTH ]]
    then
        for backup in $backups
        do
            backups_count=$(ll "$OUTPUT_DIRECTORY" -t | grep 'backup-.*\.zip$' -c)
            if [[ $backups_count > $DEPTH ]]
            then
                current_backup=$(echo "$backup" | cut -c1-17)
                rm "$OUTPUT_DIRECTORY"/"$current_backup".zip
                rm "$OUTPUT_DIRECTORY"/"$current_backup".sha1
            else
                break
            fi
        done
    fi
}

getHelpMessage() {
    echo -e "\e[1mBash Backup script\e[0m"
    echo -e "Common usage: ./bash_backup [INPUT_DIRECTORY] [FILE_EXTENSION] [OUTPUT_DIRECTORY] [REPETITIONS] [COPIES_MAX_COUNT]"
    echo -e ""
    echo -e "\e[1mMore info\e[0m"
    echo -e "[INPUT_DIRECTORY]: The directory from where you need to take the files for backup. Examples: /home/injector/Documents \e[1m!ONLY FULL PATHS TO FOLDERS!\e[0m"
    echo -e "[FILE_EXTENSION]: Which files you need to backup. Examples: txt, docx, db"
    echo -e "[OUTPUT_DIRECTORY]: The directory where your backup will be saved. Examples: /home/injector/Documents \e[1m!ONLY FULL PATHS TO FOLDERS!\e[0m"
    echo -e "[REPETITIONS]: If you need to schedule your backuping, give this param written with cron syntax. Example: '* * * * *', '0 * * * *'"
    echo -e "[COPIES_MAX_COUNT]: Max copies number. Example: 1, 2, 3, 4"
    echo -e ""
    echo -e "\e[1mExample of usage\e[0m"
    echo -e "./backup.sh /home/injector/Documents txt /home/injector/Documents/backups '* * * * *' 1"
    exit 0
}

validateArgs() {
    if [[ -z $INPUT_DIRECTORY || -z $EXT || -z $OUTPUT_DIRECTORY ]]
    then
        echo "Not enough args passed to command. Type ./backup.sh -h to see command syntax"
        exit 1;
    fi
}

if [[ $INPUT_DIRECTORY == '-h' || $INPUT_DIRECTORY == '--help' ]]
then
    getHelpMessage
fi

CRON_JOB="$REPETITIONS $(pwd)/backup.sh $INPUT_DIRECTORY $EXT $OUTPUT_DIRECTORY none $DEPTH"
filenames=$(find "${INPUT_DIRECTORY}" -maxdepth 1 -name "*.${EXT}" | sort)

backup_name="backup"-$(echo $RANDOM | md5sum | head -c 10)

if [[ -z $filenames ]]
then
    echo -e "\e[31m[ERROR]: Files not found on the given path. Please check path to folder variable\e[0m"
    exit 1
fi

# EXECUTING FUNCTIONS
validateArgs "$INPUT_DIRECTORY" "$EXT" "$OUTPUT_DIRECTORY" "$REPETITIONS" "$DEPTH"
zipFiles "$filenames" "$OUTPUT_DIRECTORY" "$backup_name"
checkSum "$filenames" "$backup_name" "$OUTPUT_DIRECTORY"
deleteOldBackups "$OUTPUT_DIRECTORY" "$DEPTH"
planJob "$REPETITIONS" "$CRON_JOB"