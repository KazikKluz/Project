resource "kubernetes_deployment_v1" "payments_mongo_depl" {
  metadata {
    name = "payments-mongo-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "payments-mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "payments-mongo"
        }
      }

      spec {
        container {
          name  = "payments-mongo"
          image = "mongo"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "payments_mongo_srv" {
  metadata {
    name = "payments-mongo-srv"
  }

  spec {
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 27017
      target_port = "27017"
    }

    selector = {
      app = "payments-mongo"
    }
  }
}

