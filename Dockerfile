# Imagen base de Java 17 (Render usa Ubuntu)
FROM openjdk:17-jdk-slim

# Copiar el WAR generado por Maven
COPY target/ProyectoSigma.war /app/ProyectoSigma.war

# Copiar también el webapp-runner (Tomcat embebido)
COPY target/dependency/webapp-runner.jar /app/webapp-runner.jar

# Definir el directorio de trabajo
WORKDIR /app

# Exponer el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "webapp-runner.jar", "ProyectoSigma.war"]
