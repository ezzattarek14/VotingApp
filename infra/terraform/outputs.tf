output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "kube_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}


output "namespace" {
  description = "Namespace used"
  value       = kubernetes_namespace.ns.metadata[0].name
}

output "postgres_password" {
  description = "Postgres password (generated). You may prefer to read it from the kubernetes secret instead."
  value       = random_password.postgres.result
  sensitive   = true
}

output "redis_password" {
  description = "Redis password (generated)."
  value       = random_password.redis.result
  sensitive   = true
}

output "postgres_release" {
  value = {
    name      = helm_release.postgresql.name
    chart     = helm_release.postgresql.chart
    namespace = helm_release.postgresql.namespace
  }
}

output "redis_release" {
  value = {
    name      = helm_release.redis.name
    chart     = helm_release.redis.chart
    namespace = helm_release.redis.namespace
  }
}
