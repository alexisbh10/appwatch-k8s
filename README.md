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
```
## Guía de Despliegue Rápido
1. Construir la imagen local
```text
docker build -t appwatch:latest .
```
2. Desplegar utilizando Terraform (IaC)
Entra en la carpeta de Terraform, inicializa e implementa:

```text
cd terraform
terraform init
terraform apply -auto-approve
```
3. Verificar el estado del despliegue
```text
kubectl get pods
kubectl get svc
```
4. Probar el endpoint de salud
Haz un reenvío de puertos local para verificar el servicio:

```text
kubectl port-forward svc/appwatch-service 8080:80
```
Y consulta la ruta en otra terminal o navegador:
```text
curl http://localhost:8080/health
```
