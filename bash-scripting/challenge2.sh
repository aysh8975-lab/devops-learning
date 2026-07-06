#!/bin/bash

# A script that automates directory and file creation.
create_dir_file() {
    local myPath=$1

    mkdir -p "$myPath"/bash_demo
    cd "$myPath/bash_demo" || return 1
    echo "This file was created by a Bash script on: $(date '+%Y-%m-%d')" > demo.txt
    echo "Directory 'bash_demo' was created and file 'demo.txt' created."
    cat demo.txt
    

}

create_dir_file "/home/aisha/bash"