#!/bin/bash

# network.sh - Script to test connectivity between VMs and handle connectivity issues.

# Usage: ./network.sh "IP_ADDRESS1 IP_ADDRESS2 ..." 
# Example: ./network.sh "192.168.1.101 192.168.1.102"

# Function to test connectivity using ping
check_connectivity() {
    local target=$1 # Get the target IP address as an argument

    # Test connectivity using ping command
    ping_output=$(ping -c 3 -W 10 "$target") # Ping the target 3 times with a timeout of 10 seconds
    ping_status=$? # Capture the exit status of the ping command

    # Log the current date in the specified format
    current_date=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$current_date - Checking connectivity to $target" >> network.log # Log the current date

    # Check if the ping command was successful
    if [ $ping_status -eq 0 ]; then
        # If successful, log the success message and display it
        echo "$current_date - Connectivity to $target is successful." | tee -a network.log
        echo "$ping_output" | tee -a network.log # Display and log the ping output
    else
        # If unsuccessful, log the failure message and display it
        echo "$current_date - Connectivity to $target is not successful." | tee -a network.log
        echo "$ping_output" | tee -a network.log # Display and log the ping output
        # Call the traceroute script if ping fails
        ./traceroute.sh "$target"
    fi
}

# Check if IP addresses are passed as arguments
if [ -z "$1" ]; then
    echo "Usage: ./network.sh \"target_IPs\""
    exit 1
fi

# Set variables for target IPs
target_IPs=($1)

# Run the connectivity test for each target IP
for ip in "${target_IPs[@]}"; do
    check_connectivity "$ip"
done
