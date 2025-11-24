############################
# ===== Build Stage ====== #
############################
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom first to cache dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -B clean package -DskipTests


############################
# ===== Run Stage ======== #
############################
FROM eclipse-temurin:17-jre   # Debian-based, stable

WORKDIR /app

# Create non-root user (Debian-compatible)
RUN groupadd --system spring && \
    useradd --system --gid spring --create-home --shell /usr/sbin/nologin spring

USER spring

# Copy app JAR
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

# JVM optimizations
ENV JAVA_OPTS="-XX:+UseG1GC -XX:+UseStringDeduplication \
               -XX:+ExitOnOutOfMemoryError \
               -Xms256m -Xmx512m"

# HEALTHCHECK (optional)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
