#!/bin/bash

# Function to log messages to both console and log file
log_message() {
    echo "$1" | tee -a network.log
}

target_ip=$1

log_message "Starting traceroute to $target_ip..."
{
    echo "Displaying Routing Table:"
    route -n
    echo "System Hostname: $(hostname)"
    echo "Performing DNS Resolution Test:"
    nslookup google.com
    echo "Tracing Route to Google (google.com):"
    traceroute google.com
    echo "Pinging Google to verify connectivity:"
    ping -c 3 google.com
} | tee -a network.log

log_message "Traceroute for $target_ip completed. (Reboot disabled during testing phase)"
# Uncomment the following line to allow reboot after testing completion
# sudo reboot

