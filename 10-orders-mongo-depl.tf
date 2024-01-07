resource "kubernetes_deployment_v1" "orders_mongo_depl" {
  metadata {
    name = "orders-mongo-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "orders-mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "orders-mongo"
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
          name  = "orders-mongo"
          image = "mongo"
          volume_mount {
            name       = "test-persistent-storage"
            mount_path = "/data/orders"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "orders_mongo_srv" {
  metadata {
    name = "orders-mongo-srv"
  }

  spec {
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 27017
      target_port = "27017"
    }

    selector = {
      app = "orders-mongo"
    }
  }
}

