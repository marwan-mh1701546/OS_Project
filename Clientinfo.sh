#!/bin/bash

# get the server details from the user
read -p "Enter the server username: " SERVER_USER
read -p "Enter the server IP address: " SERVER_IP
read -p "Enter the directory path on the server: " SERVER_DIR

# Directory to store logs on the client
LOG_DIR="$HOME/process_logs"
mkdir -p "$LOG_DIR"

# Log file name
LOG_FILE="$LOG_DIR/process_info.log"

# get the process information
{
    echo "process Tree of All Currently Running Processes:"
    pstree -A

    echo -e "\nList of Dead or Zombie Processes:"
    ps aux | awk '$8 ~ /Z/ {print $0}'

    echo -e "\nCPU Usage Related to Processes:"
    top -b -n 1 | head -n 20

    echo -e "\nMemory Usage of Running Processes:"
    free -h

    echo -e "\nTop 5 Resource-Consuming Processes (by CPU usage):"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

} > "$LOG_FILE"

# copy the log file to the server using SCP
scp "$LOG_FILE" "$SERVER_USER@$SERVER_IP:$SERVER_DIR"

#schedule the script if it is not scheduled

SCRIPT_PATH=$(realpath "$0") #gets the path of the script
CRON_JOB="0 * * * * $SCRIPT_PATH"


# Check if the cron job is already present
(crontab -l | grep -F "$SCRIPT_PATH")  
if [ $? -ne 0 ]; then #check if exit status of last command not equal to zero
    # If not present, add the cron job
    (crontab -l; echo "$CRON_JOB") | crontab -
    echo "Cron job added to run the script every hour"
else #if it is equal to zero then it is present
    echo "Cron job is already present"
fi