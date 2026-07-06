#!/bin/bash

# Script to check if a file exists and its permissions

check_file() {

    echo "Please enter the file path:"
    read file_path

    if [[ ! -f "$file_path" ]]; then
        echo "File does not exist."
        return 1
    fi

    echo "File exists!"

    if [[ -r "$file_path" ]]; then
        echo "File is readable"
    else
        echo "You do not have read permission"
    fi

    if [[ -w "$file_path" ]]; then
        echo "File is writable"
    else
        echo "You do not have write permission"
    fi

    if [[ -x "$file_path" ]]; then
        echo "File is executable"
    else
        echo "You do not have execute permission"
    fi
}

check_file