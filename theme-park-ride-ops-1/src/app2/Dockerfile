FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY src/app2/build.gradle .
COPY src/app2/src ./src
RUN ./gradlew build -x test

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]