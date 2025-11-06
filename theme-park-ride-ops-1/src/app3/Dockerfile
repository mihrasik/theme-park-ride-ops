FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY src/app3/build.gradle .
COPY src/app3/gradle gradle
COPY src/app3/src ./src
RUN ./gradlew build --no-daemon

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]