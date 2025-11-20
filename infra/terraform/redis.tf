resource "random_password" "redis" {
  length  = 12
  special = false
}


resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.0.2" # pin as needed

  namespace = kubernetes_namespace.ns.metadata[0].name

  values = [
    yamlencode({
      global = {
        storageClass = (var.storage_class != "" ? var.storage_class : null)
      }
      architecture = "standalone"  # or "replication"
      usePassword  = true
      password     = random_password.redis.result
      persistence = {
        enabled = true
        size    = var.redis_storage_size
        storageClass = (var.storage_class != "" ? var.storage_class : null)
      }
    })
  ]
}

resource "kubernetes_secret" "redis_credentials" {
  metadata {
    name      = "redis-credentials"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  data = {
    password = base64encode(random_password.redis.result)
  }

  type = "Opaque"
}
