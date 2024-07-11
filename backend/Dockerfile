# Use the official Maven image with Java 17 for building the application
FROM maven:3.8.4-openjdk-17 as build

WORKDIR /app
COPY . .

# Build the application, skipping tests for brevity
RUN mvn clean package -DskipTests

# Use OpenJDK 17 for running the application
FROM openjdk:17-jdk-slim

# Copy the jar file from the build stage to the /app directory
COPY --from=build /app/target/*.jar /app/app.jar

# Command to run the application
CMD ["java", "-jar", "/app/app.jar"]