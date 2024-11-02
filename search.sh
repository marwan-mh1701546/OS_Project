#!/bin/bash

# search.sh - Script to find files larger than 1M in the user's account
# Logs results to 'bigfile' and emails the system administrator if files are found
 
# Variables
output_file="bigfile"
admin_email="mh1701546@qu.edu.qa"
 
# Find all files larger than 1M in the user's account
echo "Searching for files larger than 1M in the account..."


{
    echo "========== Large Files Report =========="
    echo "Report Generated on: $(date)"
    echo "----------------------------------------"
    # Find and log files larger than 1M
    find ~ -type f -size +1M | tee "$output_file"
    file_count=$(find ~ -type f -size +1M | wc -l)
    echo "Number of files larger than 1M: $file_count"
    echo "----------------------------------------"
} | tee "$output_file"
 
# If the output file is not empty, email the system administrator
if [ -s "$output_file" ]; then
    echo "Large files found. Sending email to system administrator..."
    mail -s "Large Files Report" "$admin_email" < "$output_file"
fi


 
# Final message
echo "Search complete. Results saved to $output_file."
 