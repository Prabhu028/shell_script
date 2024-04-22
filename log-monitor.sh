#!/bin/bash

################################################################################
# Script Name: log_monitor.sh
# Author: Prabhusai
# Date: 22-04-2024
# Description: This script monitor's a specified log file for occurrences of
#              "error" entries and counts them in real-time. It prompts the
#              user to enter the path to the log file and continuously monitors
#              using the `tail` command.
################################################################################

# Enabling debugging mode 
set -x

# Enabling script to exit on error
set -e

# Main function
main() {
    # Prompt user for logfile location in system
    read -p "Enter the path to the log file: " log_file
    # Check's if the specified logfile exist's
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file not found."
        exit 1
    fi

    error_count='0'
    log_monitor
}

# log monitor function
log_monitor() {
    tail -n 0 -f "$log_file" | while read line; do
        analyze_log_entry "$line"
    done
}

# log analyze function
analyze_log_entry() {
    local entry="$1"
    # Example: count occurrences of "error" in log entry
    if [[ $entry == *"error"* ]]; then
        ((error_count++))
    fi
}

# summary report function
summary_report() {
    echo "Error count: $error_count"
}

# exit function
cleanup_and_exit() {
    echo "Exiting..."
    summary_report
    exit 0
}
trap cleanup_and_exit SIGINT


# Call main function
main