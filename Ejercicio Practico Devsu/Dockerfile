# ---------------------------------------------------------
# Stage 1: Build
# Usamos la imagen oficial de Maven con JDK 17 para compilar:
# - Incluye Maven preinstalado.
# - Basada en Eclipse Temurin, una distribución de OpenJDK optimizada.
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Definimos /app como directorio de trabajo dentro del contenedor.
# Todas las operaciones COPY, RUN, ENTRYPOINT se harán en este directorio.
WORKDIR /app

# Copiamos únicamente el POM al contexto de build.
# Buena práctica: al cambiar solo código pero no el POM, Docker reutiliza la caché
# de dependencias y acelera compilaciones posteriores.
COPY devsu-demo-devops-java/pom.xml .

# Pre-descargamos todas las dependencias en modo batch.
# Esto evita conexiones interactivas y acelera el build cuando cambian solo fuentes.
RUN mvn dependency:go-offline -B

# Copiamos el resto del código fuente.
# Asegúrate de ejecutar docker build desde la carpeta que contiene devsu-demo-devops-java/.
COPY devsu-demo-devops-java/src ./src

# Compilamos y empaquetamos el JAR sin ejecutar tests.
# Los tests se ejecutan en CI/CD, no en el build de la imagen, para separar responsabilidades.
RUN mvn clean package -DskipTests

# ---------------------------------------------------------
# Stage 2: Runtime
# Construimos una imagen ligera de runtime basada en OpenJDK slim.
FROM openjdk:17-jdk-slim

# Creamos un grupo y un usuario sin privilegios adicionales.
# Evita ejecutar la app como root: mejora la seguridad en producción.
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Definimos /app como directorio de trabajo para el runtime.
WORKDIR /app

# Creamos un directorio /data para almacenar los archivos de H2.
# Asignamos su propiedad a appuser para que pueda escribir sin permisos root.
RUN mkdir /data \
 && chown appuser:appgroup /data

# Configuramos la URL de la base de datos H2 en modo file-based,
# apuntando al directorio /data (escribible por appuser).
# - DB_CLOSE_ON_EXIT=FALSE: no cierra la BD al detener Spring Boot.
# - AUTO_RECONNECT=TRUE: intenta reconectar automáticamente.
ENV SPRING_DATASOURCE_URL="jdbc:h2:file:/data/test;DB_CLOSE_ON_EXIT=FALSE;AUTO_RECONNECT=TRUE"

# Copiamos el JAR compilado desde el stage "build".
# Al usar multi-stage, la imagen final no contiene Maven ni código fuente,
# solo el JAR listo para ejecutar.
COPY --from=build /app/target/*.jar app.jar

# Definimos JAVA_OPTS en variable de entorno.
# Permite ajustar memoria de la JVM al ejecutar sin tener que rebuild la imagen.
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Exponemos el puerto 8080, que es el default de Spring Boot.
EXPOSE 8080

# HEALTHCHECK permite a Docker y Kubernetes verificar la salud del contenedor.
# - --interval=30s: cada 30 segundos.
# - --timeout=5s: fallo si no responde en 5 segundos.
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Cambiamos al usuario no-root antes de iniciar la aplicación.
USER appuser

# ENTRYPOINT flexible: ejecuta el JAR con las opciones definidas en JAVA_OPTS.
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
