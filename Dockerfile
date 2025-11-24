############################
# ===== Build Stage ====== #
############################
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml to cache dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy the rest of the source
COPY src ./src

# Build the FAT JAR
RUN mvn -B clean package -DskipTests


############################
# ===== Run Stage ======== #
############################
# Debian-based JRE (safe for Spring Boot 3.x)
FROM eclipse-temurin:17-jre

WORKDIR /app

# Create non-root user (Debian syntax)
RUN groupadd --system spring && \
    useradd --system --gid spring --create-home --shell /usr/sbin/nologin spring
USER spring

# Copy app jar
COPY --from=builder /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# JVM Optimization
ENV JAVA_OPTS="-XX:+UseG1GC -XX:+UseStringDeduplication \
               -XX:+ExitOnOutOfMemoryError \
               -Xms256m -Xmx512m"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# Run the app
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
