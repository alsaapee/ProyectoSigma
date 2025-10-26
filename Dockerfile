# ====== STAGE 1: build con Maven ======
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /workspace

# Copiamos solo el pom para resolver dependencias en caché
COPY pom.xml ./
RUN mvn -q -DskipTests dependency:go-offline

# Ahora el código fuente
COPY src ./src
# Empaquetamos (esto genera target/ProyectoSigma.war)
# y descarga webapp-runner.jar a target/dependency/
RUN mvn -q -DskipTests package

# ====== STAGE 2: runtime ligero (Java 17 JRE) ======
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copiamos WAR y webapp-runner desde el stage de build
COPY --from=build /workspace/target/ProyectoSigma.war /app/ProyectoSigma.war
COPY --from=build /workspace/target/dependency/webapp-runner.jar /app/webapp-runner.jar

# Puerto interno del contenedor (Render mapea $PORT)
EXPOSE 8080

# Importante: usar $PORT de Render y servir el WAR en "/"
# Usamos shell para que se expanda $PORT
CMD ["sh","-c","java -jar webapp-runner.jar --port $PORT --path / ProyectoSigma.war"]
