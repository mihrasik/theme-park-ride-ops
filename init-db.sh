#!/bin/bash
set -e

echo "Creating user and database..."

# Wait for MariaDB to be ready
sleep 5

# Create user with proper host permissions for Docker network
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    DROP USER IF EXISTS '${DB_USER}'@'%';
    DROP USER IF EXISTS '${DB_USER}'@'localhost';
    CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
    CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
    FLUSH PRIVILEGES;
    SELECT User, Host FROM mysql.user WHERE User = '${DB_USER}';
EOSQL

echo "User ${DB_USER} created successfully with network permissions!"
echo "Testing connection..."

# Test the connection
mariadb -u "$DB_USER" -p"$DB_PASS" -h localhost "$DB_NAME" -e "SELECT 'Connection successful' as status;"