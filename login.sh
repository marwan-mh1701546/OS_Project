#!/bin/bash

# Define log file
LOGFILE="invalid_attempts.log"
MAX_ATTEMPTS=3
CORRECT_USERNAME="clientSSH" #change this to to the correct username if you have to
CORRECT_PASSWORD="123" #change this one too if you have too


# Function to log invalid attempts
log_attempt() {
    local username=$1
    echo "$(date): Invalid server login attempt for user '$username'" >> $LOGFILE
}

# Get client username

read -p "Enter Server Name: " servername
read -p "Enter Server IP: " server_ip


for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
    # Prompt for server password
    echo # Just to add a new line after password input

    read -sp "Enter password: " server_password

    # Try to log in using sshpass to handle the password for server login
   if [[ "$servername" == "$CORRECT_USERNAME" && "$server_password" == "$CORRECT_PASSWORD" ]]; then
    echo "Credentials are correct. Proceeding to SSH login..."
    
    # Attempt to SSH
    sshpass -p "$server_password" ssh -o StrictHostKeyChecking=no "$servername@$server_ip" #change ip too if you have too
    exit 0
    else
        log_attempt $(whoami)
        echo "Invalid server credentials. Attempt $attempt of $MAX_ATTEMPTS."
    fi
done

# Handle excessive invalid attempts
echo "Unauthorized server user!"

sshpass -p "$CORRECT_PASSWORD" sftp -o StrictHostKeyChecking=no "$CORRECT_USERNAME@$server_ip" << EOF
put $LOGFILE client_timestamp_invalid_attempts.log
bye
EOF

echo "Scheduling logout in 30 seconds..."
sleep 30 && pkill -KILL -u "$USER" &