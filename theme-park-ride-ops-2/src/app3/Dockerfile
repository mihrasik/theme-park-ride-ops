FROM openjdk:17-jdk-slim

VOLUME /tmp

COPY build/libs/app3-*.jar app3.jar

ENTRYPOINT ["java","-jar","/app3.jar"]