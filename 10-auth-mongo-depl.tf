resource "kubernetes_deployment_v1" "auth_mongo_depl" {
  metadata {
    name = "auth-mongo-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth-mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth-mongo"
        }
      }

      spec {
        volume {
          name = "test-persistent-storage"
          persistent_volume_claim {
            claim_name = "ebs-mongo-pv-claim"
          }
        }
        container {
          name  = "auth-mongo"
          image = "mongo"
          volume_mount {
            name       = "test-persistent-storage"
            mount_path = "/data/db"
          }
        }

      }
    }
  }
}

resource "kubernetes_service_v1" "auth_mongo_srv" {
  metadata {
    name = "auth-mongo-srv"
  }

  spec {
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 27017
      target_port = "27017"
    }

    selector = {
      app = "auth-mongo"
    }
  }
}

