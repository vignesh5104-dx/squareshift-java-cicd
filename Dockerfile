# === Build stage ===
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Build application
COPY src ./src
RUN mvn -B clean package -DskipTests

# === Run stage ===
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Copy the fat jar from builder
COPY --from=builder /app/target/*.jar app.jar

# Expose HTTP port
EXPOSE 8080

# Health check (uses actuator)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
