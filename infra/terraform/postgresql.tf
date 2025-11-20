# Create namespace
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "postgres" {
  length  = 12
  special = false
}


# Add bitnami repo (helm provider handles repo via chart repository url fields)
resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  

  namespace = kubernetes_namespace.ns.metadata[0].name

  values = [
    yamlencode({
      global = {
        storageClass = (var.storage_class != "" ? var.storage_class : null)
      }
      postgresql = {
        auth = {
          postgresPassword = random_password.postgres.result
          username         = "appuser"
          password         = random_password.postgres.result
          database         = "appdb"
        }
        persistence = {
          enabled = true
          size    = var.postgres_storage_size
          storageClass = (var.storage_class != "" ? var.storage_class : null)
        }
      }
    })
  ]
}

# optional: create Kubernetes secret with that password for other apps to use
resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  data = {
    username = base64encode("appuser")
    password = base64encode(random_password.postgres.result)
    database = base64encode("appdb")
  }

  type = "Opaque"
}
