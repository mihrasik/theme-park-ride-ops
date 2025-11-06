/theme-park-ride-ops/theme-park-ride-ops/app/ride-ops-api/Dockerfile
# Dockerfile for ride-ops-api service

FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the Maven build artifact
COPY target/ride-ops-api.jar ride-ops-api.jar

# Expose the application port
EXPOSE 8080

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=local

# Run the application
ENTRYPOINT ["java", "-jar", "ride-ops-api.jar"]