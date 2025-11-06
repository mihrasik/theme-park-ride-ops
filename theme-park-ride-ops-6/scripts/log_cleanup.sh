/theme-park-ride-ops/theme-park-ride-ops/scripts/log_cleanup.sh
#!/bin/bash

# This script cleans up old log files in the specified log directory.

LOG_DIR="/var/log/themepark"
DAYS_TO_KEEP=7

# Find and delete log files older than the specified number of days
find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_TO_KEEP -exec rm -f {} \;

echo "Log cleanup completed. Removed log files older than $DAYS_TO_KEEP days from $LOG_DIR."