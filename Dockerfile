# ===== Build Stage ====== #

FROM maven:3.9.9-eclipse-temurin-17 AS builder


# 1. Copy only pom.xml first to cache dependencies
COPY pom.xml .

# Download dependencies (cached if pom.xml unchanged)
RUN mvn -B dependency:go-offline

# 2. Copy source code
COPY src ./src

# Build the application (fat jar)
RUN mvn -B clean package -DskipTests


# ===== Run Stage ======== #

FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Create a non-root user (best practice)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Copy built jar from builder stage
COPY --from=builder /app/target/*-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# JVM Optimizations for container environments
ENV JAVA_OPTS="-XX:+UseG1GC -XX:+UseStringDeduplication \
               -XX:+ExitOnOutOfMemoryError \
               -Xms256m -Xmx512m"

# Optional health check (Spring Boot actuator)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# Run the app
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
