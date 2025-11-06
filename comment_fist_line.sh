#!/bin/bash

# Directory containing the .yaml files
DIR="/home/ubuntu/project/theme-park-ride-ops/theme-park-ride-ops-3"

# List to store files that need changes
files_to_change=()

# Iterate over all .yaml files in the directory
for file in "$DIR"/*.*; do
    # Read the first line of the file
    first_line=$(head -n 1 "$file")

    # Check if the first line is the relative path to the file
    if [[ "$first_line" == *"$file"* ]]; then
        # Add the file to the list of files that need changes
        files_to_change+=("$file")
    fi
done

# Print the full list of files that need to be updated
echo "Files that need to be updated:"
for file in "${files_to_change[@]}"; do
    echo "$file"
done