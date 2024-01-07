resource "kubernetes_deployment_v1" "expiration_redis_depl" {
  metadata {
    name = "expiration-redis-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "expiration-redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "expiration-redis"
        }
      }

      spec {
        container {
          name  = "expiration-redis"
          image = "redis"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "expiration_redis_srv" {
  metadata {
    name = "expiration-redis-srv"
  }

  spec {
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 6379
      target_port = "6379"
    }

    selector = {
      app = "expiration-redis"
    }
  }
}

