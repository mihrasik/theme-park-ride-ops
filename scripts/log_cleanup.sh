#!/bin/bash

# This script cleans up old log files in the specified log directory.

LOG_DIR="/var/log/themepark"  # Specify the log directory
DAYS_TO_KEEP=7                # Number of days to keep logs

# Find and delete log files older than the specified number of days
find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_TO_KEEP -exec rm -f {} \;

echo "Log cleanup completed. Old log files older than $DAYS_TO_KEEP days have been removed."