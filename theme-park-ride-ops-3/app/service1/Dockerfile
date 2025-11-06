/theme-park-ride-ops/theme-park-ride-ops/app/service1/Dockerfile
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the build artifact from the target directory
COPY target/service1.jar service1.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "service1.jar"]