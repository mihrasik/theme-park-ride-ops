/theme-park-ride-ops/theme-park-ride-ops/scripts/log_cleanup.sh
#!/bin/bash

# Log cleanup script
# This script removes log files older than a specified number of days.

# Configuration
LOG_DIR="./logs"  # Directory containing log files
DAYS_TO_KEEP=7    # Number of days to keep logs

# Find and delete log files older than specified days
find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_TO_KEEP -exec rm -f {} \;

echo "Old log files cleaned up from $LOG_DIR."