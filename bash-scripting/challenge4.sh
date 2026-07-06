#!/bin/bash

# A script that backs up all .txt files from one directory to another. However each time script is run it backs up to new directory

backup_files() {

# store current date into a variable needed later when creating the backup directory
    current_date=$(date +%Y-%m-%d_%H%M%S)

# prompt the user for a directory to backup
    echo "Please enter the directory you would like to backup."
    read src_dir

# check if user inputs invalid directory send error message and exit function

    if [[ ! -d "$src_dir" ]]; then

    echo "This direcotry does not exist!"

    return 1

    else
# create the backup directory with the current date/time
    new_dir="backup_"$current_date
    mkdir -p "$new_dir"

    fi

# check if the backup directory exists
if [[ -d "$new_dir" ]]; then

echo "Copying .txt files..."

# copy all .txt in source directory into the backup directory
cp "$src_dir"/*.txt "$new_dir"

echo "Backup directory created:" "$new_dir"

# count number of files in the new directory
count=$(find "$new_dir" -maxdepth 1 -type f -name "*.txt" | wc -l)

# echo the number of files backed up

echo "Backup complete! Number of files backed up: $count" 

fi

}

backup_files