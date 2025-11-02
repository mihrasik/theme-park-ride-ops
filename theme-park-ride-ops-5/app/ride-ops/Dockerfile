# /app/ride-ops/Dockerfile
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the Gradle build artifact from the root project
COPY build/libs/theme-park-ride-gradle.jar ride-ops.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "ride-ops.jar"]