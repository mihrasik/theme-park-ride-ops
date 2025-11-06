FROM openjdk:17-jdk-slim

VOLUME /tmp

COPY build/libs/app2-*.jar app2.jar

ENTRYPOINT ["java", "-jar", "/app2.jar"]