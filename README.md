# **Bash backups script**

This is a script written in bash to easily create backups. In order to run the script, you need to install it on your computer, then, in the folder with the script, enter the command

`chmod +x backup.sh`

To familiarize yourself with the syntax of the command, enter

`./backup.sh -h`

or

`./backup.sh --help`

The script is able to create a backup for files with the specified extension. It is also possible to set the backup frequency (for more information, see the syntax help). Also, when setting the COPIES_MAX_COUNT parameter, the script will save only the specified number of backups, while deleting the old ones

## **Syntax**

**Common usage:** `./bash_backup [INPUT_DIRECTORY] [FILE_EXTENSION] [OUTPUT_DIRECTORY] [REPETITIONS] [COPIES_MAX_COUNT]`

**INPUT_DIRECTORY**: The directory from where you need to take the files for backup. Only full paths to folders. Examples: `/home/injector/Documents`

**FILE_EXTENSION**: Which files you need to backup. Examples: `txt, docx, db`

**OUTPUT_DIRECTORY**: The directory where your backup will be saved. Only full paths to folders. Examples: `/home/injector/Documents` 

**REPETITIONS**: If you need to schedule your backuping, give this param written with cron syntax. Examples:` '* * * * *', '0 * * * *'`

**COPIES_MAX_COUNT**: Max copies number. Examples: `1, 2, 3, 4`

**Example of usage**
`./backup.sh /home/injector/Documents txt /home/injector/Documents/backups '* * * * *' 1`

**To check your current crontab jobs, type:** `crontab -l`

**To emply your current crontab jobs, type:** `crontab -r`

