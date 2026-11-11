# AppWatch K8s

AppWatch es un microservicio nativo de la nube desarrollado en Go, diseñado bajo estándares de seguridad y buenas prácticas de DevSecOps. El proyecto implementa un ciclo de vida completo automatizado: desde el análisis estático de código e infraestructura, pasando por contenedorización segura, hasta el despliegue declarativo en Kubernetes gestionado mediante Terraform.

## Stack Tecnológico
- **Lenguaje:** Go (Golang).
- **Contenedores:** Docker (con buenas prácticas de seguridad).
- **Orquestación:** Kubernetes (Kubernetes Deployments con sondas de salud avanzadas).
- **Infraestructura como Código (IaC):** Terraform.
- **CI/CD y Seguridad:** GitHub Actions, Gosec y Trivy (escaneo de IaC, código y contenedores).

## Pipeline DevSecOps y Seguridad
Este repositorio integra controles automatizados de seguridad en cada *push* o *pull* a la rama *main* con el objetivo de evitar vulnerabilidades antes de llegar a producción:
- **GO Unit Testing y GOSec (Análisis estático):** valida la lógica de negocio y escanea el código fuente en busca de vulnerabilidades.
- **Trivy IaC Config Scan:** analiza la configuración de los manifiestos y la infraestructura de Terraform en busca de malas prácticas de seguridad.
- **Build and Push (GHCR):** compila la imagen optimizada y la almacena de forma segura en el Registro de Contenedores de GitHub (GHCR).
- **Trivy Container Image Scan:** inspecciona la imagen compilada en busca de vulnerabilidades críticas y altas, antes de dar luz verde al despliegue.

## Estructura del repositorio
```text
appwatch-k8s/
├── .github/
│   └── workflows/
│       └── ci.yml          # Pipeline CI/CD automatizado (Gosec + Trivy + Docker + K8s)
├── k8s/
│   └── deployment.yaml     # Manifiestos de Kubernetes con securityContext y sondas
├── terraform/              # Configuración de IaC para el despliegue
│   └── main.tf
├── Dockerfile              # Imagen multi-stage con usuario no root
├── go.mod
├── go.sum
└── main.go                 # Microservicio en Go con endpoints /health y /ready
```

## 🛡️ Hardening y Buenas Prácticas Implementadas

* **Timeouts HTTP Robustos:** El servidor Go implementa `ReadTimeout`, `WriteTimeout` e `IdleTimeout` explícitos para mitigar ataques de denegación de servicio (DoS / Slowloris).
* **Contenedor No-Root:** El `Dockerfile` utiliza un usuario y grupo dedicado sin privilegios de administrador (`USER appuser`).
* **Sistema de Ficheros de Solo Lectura:** El `securityContext` del deployment de Kubernetes fuerza `readOnlyRootFilesystem: true` para prevenir la inyección de executables maliciosos en caliente.
* **Sondas de Salud (Probes):**
  * `startupProbe`: Permite gestionar arranques pesados de forma controlada.
  * `livenessProbe`: Reinicia contenedores bloqueados automáticamente.
  * `readinessProbe`: Desconecta el tráfico del Pod si la aplicación no está lista para servir peticiones.

## 🚀 Ejecución y Despliegue Local

### 1. Ejecutar el microservicio localmente (Go)

Si deseas levantar la aplicación en tu máquina de desarrollo sin contenedores:

```bash
go run main.go
```

La aplicación arrancará en el puerto `8080`. Puedes probar los endpoints de salud:
* `http://localhost:8080/health`
* `http://localhost:8080/ready`

### 2. Construir y probar el contenedor Docker localmente

Para compilar la imagen asegurándote de que cumple con las restricciones de usuario no root:

```bash
docker build -t appwatch:latest .
docker run --rm -p 8080:8080 appwatch:latest
```

### 3. Despliegue con Terraform en Kubernetes (Minikube / Kind)

Asegúrate de tener un clúster local activo (por ejemplo, Minikube o Kind) y la herramienta de Terraform instalada:

1. Inicia tu clúster local:
   ```bash
   minikube start
   # o bien: kind create cluster
   ```
2. Navega al directorio de infraestructura y despliega:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```
3. Verifica que el despliegue se ha realizado correctamente en el clúster:
   ```bash
   kubectl get deployments
   kubectl get pods
   ```
