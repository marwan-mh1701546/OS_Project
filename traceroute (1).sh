#!/bin/bash

# traceroute.sh - Script to test connectivity and handle connectivity issues.

# Function to check connectivity to a target IP
check_connectivity() {
    local target=$1 # Get the target IP address as an argument

    # Test connectivity using ping command
    ping_output=$(ping -c 3 -W 10 "$target") # Ping the target 3 times with a timeout of 10 seconds
    ping_status=$? # Capture the exit status of the ping command

    # Log the current date in the specified format
    current_date=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$current_date - Checking connectivity to $target" >> network.log # Log the current date and target

    # Check if the ping command was successful
    if [ $ping_status -eq 0 ]; then
        # If successful, log the success message and display it
        echo "$current_date - Connectivity to $target is successful." | tee -a network.log
        echo "$ping_output" | tee -a network.log # Display and log the ping output
    else
        # If unsuccessful, log the failure message and display it
        echo "$current_date - Connectivity to $target is not successful." | tee -a network.log
        echo "$ping_output" | tee -a network.log # Display and log the ping output
        # Optionally, you can include the traceroute command here if you want to run it when ping fails
        echo "Running traceroute for $target..." | tee -a network.log
        traceroute_output=$(traceroute "$target") # Run the traceroute command
        echo "$traceroute_output" | tee -a network.log # Display and log the traceroute output
    fi
}

# Check if a target IP address is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./traceroute.sh target_IP"
    exit 1
fi

# Call the function with the provided target IP
check_connectivity "$1"
