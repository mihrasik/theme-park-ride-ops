/theme-park-ride-ops/theme-park-ride-ops/app/ride-ops-ui/Dockerfile
# Dockerfile for ride-ops-ui service

FROM tomcat:9.0

COPY ./src/main/webapp /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]