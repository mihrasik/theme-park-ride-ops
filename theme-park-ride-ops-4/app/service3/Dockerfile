/theme-park-ride-ops/theme-park-ride-ops/app/service3/Dockerfile
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the target directory
COPY target/service3.jar service3.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "service3.jar"]