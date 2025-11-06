/theme-park-ride-ops/theme-park-ride-ops/app/service2/Dockerfile
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR file
COPY build/libs/service2.jar service2.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "service2.jar"]