#!/bin/sh
# Start SSH daemon in the background
/usr/sbin/sshd -D &
# Wait a moment for sshd to bind to the port
sleep 1
# Execute the Spring‑Boot application
exec java -jar /app/theme-park-ride-gradle.jar