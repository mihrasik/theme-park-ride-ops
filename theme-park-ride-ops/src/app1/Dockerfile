FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the Gradle build files
COPY build.gradle gradle.properties ./
COPY src/main/resources ./src/main/resources
COPY src/main/java ./src/main/java

# Copy the Gradle wrapper
COPY gradlew ./
COPY gradle ./gradle

# Build the application
RUN ./gradlew build -x test

# Copy the built jar file
COPY build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Define the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]