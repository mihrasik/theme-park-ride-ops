#!/bin/sh
# Start SSH daemon in the background
/usr/sbin/sshd -D &
# Wait a moment for sshd to bind to the port
sleep 5
# Execute the original MariaDB entrypoint with mysqld
exec gosu mysql mariadbd