# **🗳️ Voting Application – Production Deployment (Kubernetes + Terraform + CI/CD)**

A fully production-grade microservices application consisting of:

- **Vote Service** – Cast votes  
- **Result Service** – View aggregated results  
- **Worker Service** – Processes jobs from Redis → PostgreSQL  
- **Redis** – Queue  
- **PostgreSQL** – Database  
- **Seed Service** – Loads initial data  
- **Prometheus, Grafana, Node Exporter** – Monitoring stack  
- **AWS EKS** cluster provisioned using Terraform  
- **GitHub Actions CI/CD** with Trivy scans + Docker Hub pushes  

This system implements **enterprise DevOps standards**, including non-root containers, network isolation, health probes, Helm charts, IaC, and full observability.

---

# **📌 Features**

## **Application Architecture**
- Microservices: vote, worker, result, redis, postgres  
- Multi-stage Docker images  
- Seed image  
- ConfigMaps & Secrets  
- Resource limits & probes  
- Pod Security Standards (restricted & non-root)  
- NetworkPolicies isolating database & Redis  
- Production-grade Helm chart  

## **Infrastructure (Terraform)**
- AWS EKS  
- Node groups  
- IRSA  
- VPC, subnets, routing  
- Autoscaling  

## **Monitoring & Observability**
- Prometheus  
- Grafana  
- Node Exporter  

## **CI/CD Pipeline**
- Builds Docker images  
- Runs tests  
- Trivy vulnerability scanning  
- Pushes to Docker Hub  
- Deploys automatically to Kubernetes  

---

# **📦 Repository Structure**

.
├── vote/
├── result/
├── worker/
├── seed/
├── infra/terraform/
├── k8s/
├── helm/voting-system/
├── monitoring/
│ ├── prometheus/
│ ├── grafana/
│ └── node-exporter/
├── .github/workflows/
└── README.md



---

# **🚀 1. Setup & Deployment Instructions**

## **Prerequisites**
- AWS account + IAM user  
- kubectl, helm, terraform  
- Docker  
- GitHub Secrets configured:
  - `DOCKERHUB_USERNAME`  
  - `DOCKERHUB_TOKEN`  
  - `KUBE_CONFIG_DATA`  
  - `AWS_ACCESS_KEY_ID`  
  - `AWS_SECRET_ACCESS_KEY`  

---

## **Step 1 – Build Docker Images (Optional)**

docker build -t vote-app:latest ./vote
docker build -t result-app:latest ./result
docker build -t worker-app:latest ./worker
docker build -t seed-app:latest ./seed


---

## **Step 2 – Provision AWS EKS (Terraform)**

cd infra/terraform
terraform init
terraform apply -auto-approve


This provisions the full Kubernetes cluster, networking, and IAM roles.

---

## **Step 3 – Deploy Redis & PostgreSQL via Helm**

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install postgres bitnami/postgresql
--set auth.enablePostgresUser=true
--set primary.persistence.enabled=true

helm install redis bitnami/redis
--set auth.enabled=false
--set master.persistence.enabled=true


Both are deployed with persistence, restricted access, and best security practices.

---

## **Step 4 – Deploy the Voting Application**

### **Option A – Using Kubernetes Manifests**

kubectl apply -f k8s/


### **Option B – Using Helm Chart (Recommended)**

helm install voting-system ./helm/voting-system


This includes Secrets, ConfigMaps, Deployments, Services, Ingress, HPA, PSA, and NetworkPolicies.

---

## **Step 5 – Deploy Monitoring Stack**

kubectl apply -f monitoring/prometheus/
kubectl apply -f monitoring/grafana/
kubectl apply -f monitoring/node-exporter/


Prometheus scrapes all services & nodes; Grafana provides dashboards; Node Exporter runs as a DaemonSet.

---

## **Step 6 – CI/CD Pipeline (GitHub Actions)**

Pipeline stages:

- Build images  
- Run tests  
- Trivy filesystem scan  
- Trivy image scan  
- Push images to Docker Hub  
- Deploy to EKS  

Triggered on:

push:
branches: [main]
pull_request:


---

# **🧠 2. Design Decisions & Trade-Offs**

## **Microservices vs Monolith**
✔ Better scalability & separation  
✖ More complexity in networking

## **Multi-stage Docker Builds**
✔ Smaller, secure images  
✖ More complex Dockerfiles

## **Terraform IaC**
✔ Reproducible & scalable infra  
✖ Requires experience to manage

## **Helm Charts**
✔ Reusable & configurable  
✖ Requires templating knowledge

## **NetworkPolicies & Pod Security**
✔ Strong isolation & zero trust  
✖ Can break apps if misconfigured

## **Prometheus/Grafana Monitoring**
✔ Complete observability  
✖ Requires storage & setup effort

## **GitHub Actions**
✔ Cloud-native pipeline  
✖ Must manage secrets properly

---

# **📊 Monitoring & Alerting**
- Prometheus scrapes all services, nodes, and exporters  
- Grafana dashboards for cluster & app metrics  
- Optional: AlertManager setup  

---

# **🔐 Security**
- All containers run as **non-root**  
- Read-only root filesystem  
- Kubernetes **Pod Security Admission (restricted)**  
- Secrets stored in Kubernetes Secret objects  
- NetworkPolicies block unauthorized access to Redis/PostgreSQL  
- CI/CD performs Trivy vulnerability scanning  

---

# **🌐 Contact**

👨‍💻 **Developed By:** *Ezzat Tarek*  
🔗 **LinkedIn:**  
https://www.linkedin.com/in/ezzat-tarek-23b27324a  

---



