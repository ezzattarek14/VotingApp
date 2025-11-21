🗳️ Voting Application – Production Deployment (Kubernetes + Terraform + CI/CD)

A fully-containerized, production-ready microservices system consisting of:

Vote Service – Frontend for casting votes

Result Service – Displays aggregated results

Worker Service – Background processor (Redis → PostgreSQL)

Redis – Queue

PostgreSQL – Persistent database

Seed Service – Seeds initial data

Prometheus, Grafana, Node Exporter – Full monitoring stack

EKS Cluster (AWS) deployed with Terraform

CI/CD Pipeline (GitHub Actions) with Trivy, Docker Hub, and automated deploy

This repository demonstrates production-grade DevOps practices, including multi-stage Dockerfiles, non-root containers, pod security standards, network isolation, Helm packaging, and observability.

📌 Features
Application Architecture

✔ Microservices: vote, worker, result, redis, postgres
✔ Multi-stage Docker images for every service
✔ Seed image for initializing DB
✔ Resource requests/limits + liveness/readiness/startup probes
✔ ConfigMaps + Secrets (base64 + Kubernetes best practices)
✔ Pod Security Standards (restricted / non-root)
✔ NetworkPolicies isolating database & Redis
✔ Optional: Fully templated Helm chart for production deployments

Infrastructure (Terraform)

✔ Fully managed EKS cluster
✔ Worker nodes (scalable)
✔ IAM roles for service accounts (IRSA)
✔ VPC, Subnets, Routing, Security Groups
✔ Autoscaling enabled

Monitoring & Observability

✔ Prometheus (scrape configs, service monitors)
✔ Grafana dashboards
✔ Node Exporter (DaemonSet)

CI/CD Pipeline (GitHub Actions)

✔ Build multi-stage Docker images
✔ Run tests
✔ Trivy vulnerability scanning
✔ Push images to Docker Hub
✔ Deploy to Kubernetes using manifests/Helm
✔ Optional: smoke testing stage

📦 Repository Structure
.
├── vote/
├── result/
├── worker/
├── seed/
├── infra/terraform/        # EKS provisioning
├── k8s/                    # Manifest-based deployment
├── helm/voting-system/     # Production Helm chart
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── node-exporter/
├── .github/workflows/      # CI/CD pipeline
└── README.md

🚀 1. Setup & Deployment Instructions
Prerequisites

AWS account + IAM user

kubectl, helm, awscli

Terraform ≥ 1.0

Docker

GitHub Actions configured with:

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

KUBE_CONFIG_DATA

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

Step 1 – Build Images Locally (Optional)
docker build -t vote-app:latest ./vote
docker build -t result-app:latest ./result
docker build -t worker-app:latest ./worker
docker build -t seed-app:latest ./seed


Each Dockerfile is multi-stage (builder + runtime), non-root, minimized.

Step 2 – Provision AWS EKS via Terraform
cd infra/terraform
terraform init
terraform plan
terraform apply


Outputs:

kubeconfig

node groups

VPC networking

IAM roles (IRSA)

Step 3 – Deploy Dependencies (Redis + PostgreSQL)
Using Helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgres bitnami/postgresql --set auth.enablePostgresUser=true ...
helm install redis bitnami/redis --set auth.enabled=false ...


enabled persistence

restricted NetworkPolicy

non-root security rules

Step 4 – Deploy the Voting App
Option A – Using Manifests
kubectl apply -f k8s/

Option B – Using Helm (recommended)
helm install voting-system ./helm/voting-system


Includes:

ConfigMaps / Secrets

Deployments

Services

Ingress

NetworkPolicies

PodSecurity (restricted)

HPA (optional)

Step 5 – Deploy Monitoring Stack
kubectl apply -f monitoring/prometheus
kubectl apply -f monitoring/grafana
kubectl apply -f monitoring/node-exporter


Node Exporter runs as a DaemonSet on all nodes.

Grafana UI becomes available via LoadBalancer / Ingress.

Step 6 – CI/CD Pipeline (GitHub Actions)

Pipeline includes:

Build Docker images

Run tests

Trivy scan (FS + image mode)

Push to Docker Hub

Deploy automatically to EKS

Triggered on:

push:
  branches: [ main ]
pull_request:

🧠 2. Design Decisions & Trade-offs
Microservices over monolith

✔ Easy scaling
✔ Independent deployments
✖ More complexity in networking + monitoring

Multi-stage Docker builds

✔ Reduced image size
✔ Faster CI/CD
✔ Secure (non-root)
✖ More complex Dockerfiles

Terraform for cluster provisioning

✔ Infrastructure-as-Code repeatability
✔ Environment parity
✖ Initial learning curve is high

Helm charts instead of raw manifests

✔ Reusable
✔ Parameterized
✔ Production values support
✖ Requires more initial setup compared to plain YAML

NetworkPolicies & PSA (restricted)

✔ Strong isolation
✔ Zero trust networking
✖ Can break communication if misconfigured

Prometheus + Grafana

✔ Enterprise-grade observability
✔ Extensible dashboards
✖ Requires storage + configuration effort

GitHub Actions for CI/CD

✔ Simple, cloud-native
✔ Integrated security scanning (Trivy)
✖ Requires secrets handling & GitHub environment setup

📊 Monitoring & Alerting

Prometheus scrapes:

vote / worker / result (custom metrics optional)

Node Exporter

Kubernetes components

Grafana dashboards

Node performance

Pod CPU/memory

Redis + PostgreSQL (optional exporters)

AlertManager (optional addition)

🔐 Security

All containers run as:

non-root

read-only root filesystem

Pod Security Admission (PSA: restricted)

Secrets stored as Kubernetes secret objects

NetworkPolicy isolating:

PostgreSQL from unauthorized pods

Redis queue from non-worker pods

CI/CD includes:

Trivy filesystem scan

Trivy image scan

🌐 Contact & Social

👨‍💻 Developed by: Ezzat Tarek
🔗 LinkedIn:
https://www.linkedin.com/in/ezzat-tarek-23b27324a

📄 License

MIT License – free to use, modify, and distribute.
