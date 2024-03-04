#!/bin/bash

################################################################################
# Script Name: exercise-1.sh
# Description: This script processes a file_diff.txt file to create directories
#              and move files based on their status (added, removed) into the
#              deployPackage directory. It also generates added.txt and removed.txt
#              files containing the list of added and removed files respectively.
# Author: Kervin Rey H. Balibagoso
# Usage: This script assumes the existence of a file_diff.txt file in the current directory.
#        To execute the script, run it using:  ./exercise-1.sh
################################################################################

# Initialize variables
deploy_package_path="deployPackage"
added_path="$deploy_package_path/added"
removed_path="$deploy_package_path/removed"
added_files=""
removed_files=""

# Create necessary directories
mkdir -p $added_path
mkdir -p $removed_path

# Read each line of file_diff.txt and process accordingly
while IFS= read -r line || [[ -n $line ]]; do

    # Extract column 1 from the line (status of the file)
    status=$(echo "$line" | awk '{print $1}')

    # Extract column 2 from the line and remove any carriage return character
    filepath=$(echo "$line" | awk '{print $2}' | tr -d '\r')

    # Extract filename from the filepath
    filename=$(basename "$filepath")

    # Process based on file status
    if [[ "$status" == "M" || "$status" == "A" ]]; then
        added_files+="$filename\n"
        cp "$filepath" "$added_path"
    elif [[ "$status" == "R" || "$status" == "D" ]]; then
        removed_files+="$filename\n"
        cp "$filepath" "$removed_path"
    fi

done <file_diff.txt

# Generate added.txt and removed.txt files
echo -e "$added_files" > "added.txt"
echo -e "$removed_files" > "removed.txt"
