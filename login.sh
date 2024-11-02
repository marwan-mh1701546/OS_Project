#!/bin/bash


LOGFILE="invalid_attempts.log"
MAX_ATTEMPTS=3
CORRECT_USERNAME="server" #we have to change this to to the correct username
CORRECT_PASSWORD="#cmps450#" # and the password needs to be correct



#function that will log invalid attempts to the logfile
log_attempt() {
    local username=$1
    echo "$(date): Invalid server login attempt for user '$username'" >> $LOGFILE
}




# we read the servername and the ip from the client
read -p "Enter Server Name: " servername
read -p "Enter Server IP: " server_ip 
# the server ip has to be correct otherwise sftp is not gonna work

for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
    
    echo 
    #we get the password for the server here
    read -sp "Enter password: " server_password

    # check here if the credentials are correct
   if [[ "$servername" == "$CORRECT_USERNAME" && "$server_password" == "$CORRECT_PASSWORD" ]]; then
    echo "Credentials are correct proceeding to SSH login..."
    
    # login using SSH
    sshpass -p "$server_password" ssh -o StrictHostKeyChecking=no "$servername@$server_ip" 
    exit 0


    else
        log_attempt $(whoami)
        echo "Invalid server credentials. Attempt $attempt of $MAX_ATTEMPTS."
    fi
done

# if the loop exits it means that max attemps have been reached
echo "Unauthorized server user!"

sshpass -p "$CORRECT_PASSWORD" sftp -o StrictHostKeyChecking=no "$CORRECT_USERNAME@$server_ip" << EOF
put $LOGFILE client_timestamp_invalid_attempts.log
bye
EOF


echo "Scheduling logout in 30 seconds... bye bye"
sleep 30 && pkill -KILL -u "$USER" &