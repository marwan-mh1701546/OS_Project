#!/bin/bash

# System.sh - Script to display disk and memory usage details for the HOME directory
# This script will generate logs for disk usage, memory, CPU details, and save them to log files.
# Written for Operating Systems Lab (CMPS 405)

# Function to log disk usage information
log_disk_usage() {
    echo "Gathering disk usage information for HOME directory..."
    local log_file="disk_info.log"
    {
        echo "========== Disk Usage Report =========="
        echo "Report Generated on: $(date)"
        echo "----------------------------------------"
        echo "Total Disk Space in HOME Directory:"
        du -sh ~ 2>/dev/null
        echo "\nDisk Usage for Directories and Subdirectories in HOME Directory:"
        du -h ~ --max-depth=2 2>/dev/null
        echo "----------------------------------------"
    } | tee "$log_file"
    echo "Disk usage information saved to $log_file"
}

# Function to log memory and CPU details
log_memory_cpu_info() {
    echo "Collecting memory and CPU information..."
    local log_file="mem_cpu_info.log"
    {
        echo "========== Memory and CPU Info =========="
        echo "Report Generated on: $(date)"
        echo "-----------------------------------------"
        # Memory usage information (free and used memory percentage)
        echo "Memory Usage Summary:"
        free_output=$(free -m)
        total_memory=$(echo "$free_output" | awk '/^Mem:/ {print $2}')
        used_memory=$(echo "$free_output" | awk '/^Mem:/ {print $3}')
        free_memory=$(echo "$free_output" | awk '/^Mem:/ {print $4}')
        used_percentage=$(( (used_memory * 100) / total_memory ))
        free_percentage=$(( (free_memory * 100) / total_memory ))
        echo "Used Memory: $used_percentage%"
        echo "Free Memory: $free_percentage%"
        echo "-----------------------------------------"
        # CPU information
        echo "CPU Information:"
        cpu_model=$(lscpu | grep "Model name" | awk -F ':' '{print $2}' | sed 's/^ *//g')
        cpu_cores=$(lscpu | grep "^CPU(s):" | awk -F ':' '{print $2}' | sed 's/^ *//g')
        echo "CPU Model: $cpu_model"
        echo "Number of CPU Cores: $cpu_cores"
        echo "-----------------------------------------"
    } | tee "$log_file"
    echo "Memory and CPU information saved to $log_file"
}

# Main execution starts here
# Log disk usage and memory/CPU info
log_disk_usage
log_memory_cpu_info

# Final message
echo "All system information has been collected and logged."