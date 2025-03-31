
# Stage 1: Build the application
FROM maven:3.6.0-jdk-8 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and dependency information first
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:8-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/dental-management-system-0.0.1-SNAPSHOT.jar app.jar

# Expose the application's port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
