FROM openjdk:17-jdk-slim

VOLUME /tmp

COPY build/libs/app1-*.jar app1.jar

ENTRYPOINT ["java","-jar","/app1.jar"]