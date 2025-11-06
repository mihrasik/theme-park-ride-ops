#!/bin/bash
set -e

# Start SSH in background
echo "Starting SSH daemon..."
/usr/sbin/sshd -D &
SSHD_PID=$!

# === Let the OFFICIAL entrypoint do ALL initialization ===
echo "Initializing MariaDB (official entrypoint)..."
/usr/local/bin/docker-entrypoint.sh mariadbd &
INIT_PID=$!

# Wait for the official entrypoint to finish (it exits when done)
echo "Waiting for MariaDB initialization to complete..."
wait $INIT_PID

# === Now start the real server ===
echo "Starting final MariaDB server..."
exec gosu mysql mariadbd "$@"