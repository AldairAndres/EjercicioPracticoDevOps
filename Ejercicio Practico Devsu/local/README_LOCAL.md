# Entorno Local: Flujo Completo

Este documento describe paso a paso cómo construir, ejecutar y probar la aplicación **prueba-devops-java** en un entorno local usando Docker y Kubernetes (Docker Desktop).

---

## 1. Construcción de la imagen Docker

### Comando

docker build -t prueba-devops-java:latest .

### Detalle de cada parte

- **docker build**: inicia el proceso de construcción de una imagen a partir de un Dockerfile.
- **-t prueba-devops-java****:latest**: etiqueta la imagen con el nombre `prueba-devops-java` y la etiqueta (tag) `latest`. Permite referenciarla fácilmente en comandos posteriores.
- **.**: contexto de construcción, indica que el Dockerfile y todos los archivos necesarios están en el directorio actual.

### Por qué es importante

- Facilita la gestión de versiones de la imagen.
- Permite utilizar la misma imagen en distintos entornos sin reconstruirla.

---

## 2. Ejecución local de la imagen Docker

### 2.1. Mapeo de puertos 8080→8080

docker run --rm -p 8080:8080 prueba-devops-java:latest

**Explicación:**

- `docker run`: arranca un nuevo contenedor.
- `--rm`: elimina automáticamente el contenedor cuando se detiene.
- `-p 8080:8080`: mapea el puerto `8080` del host al puerto `8080` del contenedor.
- `prueba-devops-java:latest`: imagen que se va a ejecutar.

**Resultado:** la aplicación estará accesible en `http://localhost:8080`.

---

### 2.2. Mapeo de puertos 8080→8000

docker run --rm -p 8080:8000 prueba-devops-java:latest

**Contexto:** usar cuando la app dentro del contenedor escucha en el puerto 8000.

**Detalle:**

- `-p 8080:8000` significa que las peticiones a `localhost:8080` se redirigen al puerto `8000` del contenedor.

---

### 2.3. Forzar puerto interno con variable de entorno

docker run --rm -p 8080:8080 -e SERVER_PORT=8080 prueba-devops-java:latest

**Explicación de flags:**

- `-e SERVER_PORT=8080`: define la variable de entorno `SERVER_PORT` dentro del contenedor.

**Propósito:**

- Permite cambiar el puerto en el que Spring Boot arranca, sin modificar el código ni el Dockerfile.
- Unifica el puerto interno y externo, facilitando la configuración de Kubernetes después.

---

## 3. Verificación de la API con `curl`

### 3.1. Obtener lista de usuarios

curl http://localhost:8080/api/users

- Realiza una petición GET al endpoint `/api/users`.
- Muestra en consola la respuesta JSON con la lista de usuarios.

### 3.2. Inspeccionar cabeceras y seguir redirecciones

curl -i -L http://localhost:8080/api

- `-i`: incluye cabeceras HTTP en la salida.
- `-L`: sigue automáticamente cualquier redirección.

**Uso:**

- Validar códigos de estado (200, 301, 302, etc.).
- Verificar la ubicación de redirecciones y encabezados de contenido.

---

## 4. Despliegue en Kubernetes (Docker Desktop)

### 4.1. Aplicar los manifiestos K8s

kubectl apply -f k8s/

**Qué incluye la carpeta **``**:**

- `deployment.yaml`: define el Deployment de la app.
- `service.yaml`: expone la app como servicio interno.
- `ingress.yaml`: reglas de Ingress para routing HTTP.
- `hpa.yaml`: Horizontal Pod Autoscaler.
- `load-generator.yaml`: Deployment que genera carga interna.

**Propósito:** desplegar todos los recursos en un solo comando.

---

### 4.2. Comprobar estado de Pods, Services e Ingress

kubectl get pods
kubectl get svc
kubectl get ingress


- `kubectl get pods`: lista los Pods y su estado (`Running`, `Pending`, `CrashLoopBackOff`).
- `kubectl get svc`: muestra los Services y sus ClusterIP.
- `kubectl get ingress`: revisa los hosts y paths configurados.

---

### 4.3. Seguir logs de la aplicación

kubectl logs -l app=prueba-java -f


- `-l app=prueba-java`: filtra logs de los Pods con esa etiqueta.
- `-f`: sigue en tiempo real, útil para ver errores de arranque.

---

## 5. Exposición local con port-forward

### 5.1. Port-forward al Service

kubectl port-forward svc/prueba-java-svc 8080:80


- Expone `localhost:8080` → puerto `80` del Service.
- El Service internamente reenvía al contenedor.

### 5.2. Port-forward al Ingress Controller

kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

- Permite acceder a la lógica de Ingress (host-based routing) desde `localhost:8080`.

---

## 6. Configuración de DNS local (hosts)

Editar el archivo de hosts de Windows (`C:\Windows\System32\drivers\etc\hosts`):

127.0.0.1 kubernetes.docker.internal
127.0.0.1 devsu-demo-devops-java.com

- Resuelve `kubernetes.docker.internal` y tu dominio de prueba a `127.0.0.1`.

---

## 7. Autoescalado con HPA

### 7.1. Aplicar la configuración de HPA

kubectl apply -f k8s/hpa.yaml

- Crea un `HorizontalPodAutoscaler` que monitoriza la media de CPU y escala el Deployment entre 2 y 5 réplicas si supera el 50%.

### 7.2. Monitorizar la evolución del HPA

kubectl get hpa -w

- `-w`: watch, actualiza en tiempo real el número de réplicas y la métrica de CPU.

---

