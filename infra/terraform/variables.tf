variable "region" {
  description = "AWS region to deploy the EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "node_count" {
  description = "Number of nodes in EKS node group"
  type        = number
  default     = 2
}

 
variable "vote_image" {
  description = "ECR URI for vote app image"
  type        = string
  default     = "605789054429.dkr.ecr.us-east-1.amazonaws.com/vote-app:latest"
}

variable "result_image" {
  description = "ECR URI for result app image"
  type        = string
  default     = "605789054429.dkr.ecr.us-east-1.amazonaws.com/result-app:latest"
}

variable "worker_image" {
  description = "ECR URI for worker app image"
  type        = string
  default     = "605789054429.dkr.ecr.us-east-1.amazonaws.com/worker:latest"
}


variable "node_instance_type" {
  type    = string
  default = "m7i-flex.large"  
}

locals {
  name_prefix = "devops"   
  namespace   = "voting"   
}


variable "kubeconfig_path" {
  description = "Path to kubeconfig file (defaults to ~/.kube/config when empty)"
  type        = string
  default     = "~/.kube/config"
}


variable "storage_class" {
  description = "StorageClass name to use for PVCs. Leave empty to use cluster default."
  type        = string
  default     = ""
}

variable "postgres_storage_size" {
  description = "Persistent volume size for PostgreSQL"
  type        = string
  default     = "2Gi"
}

variable "redis_storage_size" {
  description = "Persistent volume size for Redis (data)"
  type        = string
  default     = "2Gi"
}
variable "namespace" {
  type    = string
  default = "voting"
}
