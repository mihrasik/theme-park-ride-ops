/theme-park-ride-ops/theme-park-ride-ops/app/mariadb/Dockerfile
FROM mariadb:latest

ENV MYSQL_DATABASE=${DB_NAME}
ENV MYSQL_USER=${DB_USER}
ENV MYSQL_PASSWORD=${DB_PASS}
ENV MYSQL_ROOT_PASSWORD=${DB_ROOT_PASS}

COPY ./init-db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld"]