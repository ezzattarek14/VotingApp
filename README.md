# DevOps Voting App Project

## Overview
This project demonstrates a full DevOps workflow for a microservices-based voting application. It covers containerization, Kubernetes deployment, infrastructure provisioning with Terraform, Helm charts for databases, and CI/CD automation.

The project is divided into three main phases:

1. **Containerization & Local Setup**
2. **Infrastructure & Deployment**
3. **Automation, Security & Observability**

---

## Phase 1 – Containerization & Local Setup

### Services
- `vote` – Frontend service (port 8080)
- `result` – Frontend service (port 8081)
- `worker` – Background job processor
- `redis` – Caching service
- `postgres` – Relational database
- Optional `seed-data` – Pre-populates test votes

### Docker Setup
- Each service has a **Dockerfile** configured for non-root execution.
- Efficient, minimal images used to reduce footprint.
- Docker Compose orchestrates services with two-tier networking:
  - Frontend tier: `vote` + `result`
  - Backend tier: `worker` + `redis` + `postgres`
- Health checks implemented for `redis` and `postgres`.
- Local deployment:
  ```bash
  docker compose up
All services communicate successfully and are healthy.


Phase 2 – Infrastructure & Deployment
Cluster Provisioning
AWS EKS cluster provisioned with Terraform (can be adapted to AKS, minikube, k3s, or microk8s).

Multi-environment support using variables and Terraform workspaces.

Networking configured with security groups and VPC settings.

Ingress controller deployed via Helm (ingress-nginx).

Kubernetes Deployment
Services deployed using Kubernetes manifests and Helm charts:

vote-app.yaml, result-app.yaml, worker.yaml, secrets.yaml, configmap.yaml, networkpolicy.yaml, namespace.yaml, ingress.yaml

Databases deployed via Helm (bitnami/postgresql, bitnami/redis) with:

Persistence enabled

Restricted access

Security and best practices:

Non-root policies enforced (Pod Security Admission)

NetworkPolicies isolate database pods

ConfigMaps and Secrets used for configuration and sensitive data

Resource limits and probes configured

Deployment Commands

terraform init
terraform apply

Phase 3 – Automation, Security & Observability
CI/CD Pipeline
Built using GitHub Actions:

Docker image build & push

Test execution

Security scans with Trivy

Automated deployment to Kubernetes

(Optional) Smoke tests for endpoints

(Optional) Infrastructure automation workflow

Monitoring
Prometheus and Grafana for metrics collection and visualization.

Security
IAM roles for EKS & Helm access

RBAC and PSA policies enforced

NetworkPolicies restrict internal traffic

SAST/DAST integrated into CI pipeline


Project Structure
arduino
Copy code
├── terraform/
│   ├── main.tf
│   ├── eks.tf
│   ├── vpc.tf
│   ├── iam.tf
│   ├── providers.tf
│   ├── kubectl.tf
│   └── variables.tf
├── k8s/
│   ├── configmap.yaml
│   ├── ingress.yaml
│   ├── namespace.yaml
│   ├── networkpolicy.yaml
│   ├── result-app.yaml
│   ├── secrets.yaml
│   ├── vote-app.yaml
│   └── worker.yaml
├── docker/
│   ├── Dockerfile.vote
│   ├── Dockerfile.result
│   ├── Dockerfile.worker
│   └── docker-compose.yaml
├── .github/workflows/
│   └── ci-cd.yaml
└── README.md
Design Decisions & Trade-offs
Local vs Cloud Cluster: Local Kubernetes (minikube/k3s) was suitable for development; AWS EKS ensures production-grade deployment.

Helm vs Manifests: Databases managed via Helm for persistence, versioning, and simplified upgrades; app services deployed via manifests.

Security: Non-root policies and NetworkPolicies protect against accidental or malicious access. Secrets managed via Kubernetes Secrets.

CI/CD: GitHub Actions chosen for simplicity and cloud integration. Security scanning integrated to catch vulnerabilities early.

Persistence: Postgres and Redis use EBS-backed storage classes to ensure durability.

Deployment Instructions
Local Setup


cd docker/
docker compose up
AWS EKS Deployment


cd terraform/
terraform init
terraform apply
Ensure your kubeconfig points to the new cluster.

Verify Services


kubectl get pods -n voting
kubectl get svc -n voting
Access App

Frontend: http://<ingress-lb-dns>/vote

Results: http://<ingress-lb-dns>/result
