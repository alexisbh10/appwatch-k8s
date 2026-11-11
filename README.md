🛡️ Hardening y Buenas Prácticas Implementadas

Timeouts HTTP Robustos: El servidor Go implementa ReadTimeout, WriteTimeout e IdleTimeout explícitos para mitigar ataques de denegación de servicio (DoS / Slowloris).

Contenedor No-Root: El Dockerfile utiliza un usuario y grupo dedicado sin privilegios de administrador (USER appuser).

Sistema de Ficheros de Solo Lectura: El securityContext del deployment de Kubernetes fuerza readOnlyRootFilesystem: true para prevenir la inyección de executables maliciosos en caliente.

Sondas de Salud (Probes):

startupProbe: Permite gestionar arranques pesados de forma controlada.

livenessProbe: Reinicia contenedores bloqueados automáticamente.

readinessProbe: Desconecta el tráfico del Pod si la aplicación no está lista para servir peticiones.

🚀 Ejecución y Despliegue Local

1. Ejecutar el microservicio localmente (Go)

Si deseas levantar la aplicación en tu máquina de desarrollo sin contenedores:

go run main.go


La aplicación arrancará en el puerto 8080. Puedes probar los endpoints de salud:

http://localhost:8080/healthz

http://localhost:8080/readyz

2. Construir y probar el contenedor Docker localmente

Para compilar la imagen asegurándote de que cumple con las restricciones de usuario no root:

docker build -t appwatch:latest .
docker run --rm -p 8080:8080 appwatch:latest


3. Despliegue con Terraform en Kubernetes (Minikube / Kind)

Asegúrate de tener un clúster local activo (por ejemplo, Minikube o Kind) y la herramienta de Terraform instalada:

Inicia tu clúster local:

minikube start
# o bien: kind create cluster


Navega al directorio de infraestructura y despliega:

cd terraform
terraform init
terraform apply


Verifica que el despliegue se ha realizado correctamente en el clúster:

kubectl get deployments
kubectl get pods


👨‍💻 Autor

Desarrollado por Alexis como parte de un proyecto de demostración de ingeniería Cloud, Kubernetes y prácticas avanzadas de DevSecOps.