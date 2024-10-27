#!/bin/bash

# Define log file
LOGFILE="perm_change.log"

# Find files with permission 777
echo "Searching for files with permission 777..."
files=$(find / -type f -perm 0777 2>/dev/null)

# Check if any files were found
if [ -z "$files" ]; then
    echo "No files found with permission 777."
else
    echo "Files with permission 777:"
    echo "$files"

    # Change permissions to 700 and log changes
    for file in $files; do
        chmod 700 "$file"
        echo "Changed permissions for: $file" >> "$LOGFILE"
    done
fi

# Display log content
echo "Changes logged in $LOGFILE:"
cat "$LOGFILE"
