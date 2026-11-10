# AppWatch K8s

Proyecyo de infraestructura como código (IaC) de grado de producción que despliega un microservicio de salud en Go sobre Kubernetes, automatizado completamente mediante Terraform.

## Stack Tecnológico

- **Lenguaje:** Go (Golang)
- **Contenedorización:** Docker (Build multi-etapa)
- **Orquestación:** Kubernetes (Deployments y services)
- **Infraestructura como Código (IaC):** Terraform (Gestión automatizada del clúster)

---

## Estructura del repositorio

```text
appwatch-k8s/
├── k8s/                  # Manifiestos nativos de Kubernetes
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/            # Configuración de IaC con Terraform
│   ├── main.tf
│   └── deployments.tf
├── Dockerfile            # Imagen multi-stage optimizada
└── main.go               # Código fuente del microservicio en Go