#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "Usage: backup.sh target_directory_name destination_directory_name"
  exit 1
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit 1
fi

# [TASK 1] Set up target and destination directories
targetDirectory=$1
destinationDirectory=$2

# [TASK 2] Display progress information
echo "Starting the backup process..."
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3] Generate the current timestamp
currentTS=$(date +%s)

# [TASK 4] Define the backup filename
backupFileName="backup-$currentTS.tar.gz"

# [TASK 5] Store the original directory path
origAbsPath=$(pwd)

# [TASK 6] Move to the destination directory and store absolute path
cd "$destinationDirectory"
destDirAbsPath=$(pwd)

# [TASK 7] Return to the target directory
cd "$origAbsPath"
cd "$targetDirectory"

# [TASK 8] Define timestamp for files modified yesterday
yesterdayTS=$(($currentTS - 86400)) # 24 hours ago in seconds

# Declare an array to store files to back up
declare -a toBackup

# [TASK 9] List all files and directories
for file in $(ls)
do
  # [TASK 10] Check if the file was modified in the last 24 hours
  if [[ $(date -r "$file" +%s) > $yesterdayTS ]]
  then
    # [TASK 11] Add the file to the toBackup array
    toBackup+=("$file")
  fi
done

# [TASK 12] Create and compress the backup file
if [[ ${#toBackup[@]} -gt 0 ]]
then
  tar -czf "$backupFileName" "${toBackup[@]}"
  echo "Backup file $backupFileName created successfully."

  # [TASK 13] Move the backup file to the destination directory
  mv "$backupFileName" "$destDirAbsPath"
  echo "Backup file moved to $destDirAbsPath."
else
  echo "No files were updated in the last 24 hours. No backup created."
fi
