#Author : Prasanth Kottakota
#Description : The bash file moves the original zip file from source to destination ,unzip the file which we downlaoded from balackboard of selected users, it then created folders with naming as their netid, and then moves the respective files to folders, and also it extracts the users .tar.gz file in the respecive folder
#Inputs : Change source_dir, dest_dir and assignment_name when required
#Command : place the file in any linux directory of your machine, and execute using bash <file_name>.sh

#!/bin/bash

# Assignment Name
assignment_name="Hello World"

# Source directory where the ZIP file is located
source_dir="/mnt/c/Users/kpsag/Downloads/gradebook_13847.1241_Hello20World_2023-09-14-12-03-44.zip"

# Destination directory where you want to organize the files
dest_dir="/home/pkottako/PA0/"

# Create the destination directory if it doesn't exist
mkdir -p "$dest_dir"

# Unzip the specified ZIP file to the destination directory
unzip "$source_dir" -d "$dest_dir"

# Regular expression to match the timestamp pattern "YYYY-MM-DD-HH-MM-SS"
timestamp_pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}"

# Iterate through each file in the destination directory
for file in "$dest_dir"/*; do
    if [ -f "$file" ]; then
	    # Extract the common prefix(netid) from the filename
        prefix=$(basename "$file" | sed -n 's/'"$assignment_name"'_\(.*\)_attempt_.*$/\1/p')
        # Extract the filename without path
        filename=$(basename "$file")

        # Use a regular expression to match the timestamp pattern and capture it
        if [[ "$filename" =~ ($timestamp_pattern) ]]; then
            # Extract the captured timestamp and store it in a variable
            captured_timestamp="${BASH_REMATCH[1]}"

            # Use sed to capture everything after the timestamp
            captured_value=$(echo "$filename" | sed "s/.*_${captured_timestamp}_//")

            # Create a folder named "netid" if it doesn't exist
            folder_name="$dest_dir/$prefix"
            mkdir -p "$folder_name"

            # Check if the file is a .tar.gz file
            if [[ "$captured_value" == *.tar.gz ]]; then
                # Extract the .tar.gz file into the folder
                tar -xzvf "$file" -C "$folder_name"

                # Remove the extracted .tar.gz file
                rm -f "$file"
            else
                # Move regular files to the "netid" folder with the captured value as the filename
                mv "$file" "$folder_name/$captured_value"
            fi
        fi
    fi
done

