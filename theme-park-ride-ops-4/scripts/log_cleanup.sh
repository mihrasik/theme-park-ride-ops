/theme-park-ride-ops/theme-park-ride-ops/scripts/log_cleanup.sh
#!/bin/bash

# Log cleanup script for Theme Park Ride Ops

# Define log directory
LOG_DIR="./logs"

# Check if log directory exists
if [ -d "$LOG_DIR" ]; then
    # Find and delete log files older than 7 days
    find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm -f {} \;
    echo "Old log files deleted from $LOG_DIR."
else
    echo "Log directory $LOG_DIR does not exist."
fi