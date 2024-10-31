#!/bin/bash

# Verify and install missing network tools
if ! command -v ping &> /dev/null || ! command -v traceroute &> /dev/null; then
    echo "Required network tools not found, installing..."
    sudo apt-get update && sudo apt-get install -y iputils-ping traceroute
    echo "Network tools successfully installed."
fi

# Function to execute traceroute if ping fails
execute_traceroute() {
    local target=$1
    echo "Initiating traceroute to $target..."
    ./traceroute.sh "$target"
}

# Initialize counters for summary
checks_total=0
successful_checks=0
failed_checks=0

# Define retry limits
retry_limit=3

# Iterate over each target IP passed as arguments
for target in "$@"; do
    echo "Checking connectivity for $target (Maximum attempts: $retry_limit)"
    checks_total=$((checks_total + 1))
    attempt_count=1
    connection_success=false

    # Retry pinging up to retry_limit times
    while (( attempt_count <= retry_limit )); do
        echo "Attempt $attempt_count: Pinging $target..."
        
        # Ping with 5-second timeout
        if ping -c 1 -W 5 "$target" &> /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Successful connection to $target." | tee -a network.log
            successful_checks=$((successful_checks + 1))
            connection_success=true
            break  # Stop retries on success
        else
            echo "Attempt $attempt_count failed to reach $target."
        fi
        attempt_count=$((attempt_count + 1))
    done

    # Execute traceroute if all attempts fail
    if [ "$connection_success" = false ]; then
        echo "All attempts failed for $target. Executing traceroute..."
        execute_traceroute "$target"
        failed_checks=$((failed_checks + 1))
    fi

done

# Generate final summary report
echo "📊 Connectivity Test Summary 📊"
echo "Total Targets Tested: $checks_total"
echo "Successful Connections: $successful_checks"
echo "Failed Connections: $failed_checks"
