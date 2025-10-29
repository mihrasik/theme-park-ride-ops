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

# Wait for MariaDB to start
until mariadb-admin ping -h localhost -u app  -papp --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Create a new database and user with the credentials from Vagrantfile
# mariadb -u root -p"$MARIADB_ROOT_PASSWORD" <<EOF
# CREATE DATABASE IF NOT EXISTS '$MARIADB_DBNAME';
# CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER';
# GRANT ALL PRIVILEGES ON '$MARIADB_DBNAME'.* TO '$MARIADB_USER'@'%';
# FLUSH PRIVILEGES;
# EOF

# Create a new database and user with hardcoded credentials
mariadb -u root -proot <<EOF
CREATE DATABASE IF NOT EXISTS parkdb;
CREATE USER 'app'@'localhost' IDENTIFIED BY 'app';
GRANT ALL PRIVILEGES ON parkdb.* TO 'app'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Database and user created."