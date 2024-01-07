resource "kubernetes_deployment_v1" "tickets_mongo_depl" {
  metadata {
    name = "tickets-mongo-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "tickets-mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "tickets-mongo"
        }
      }

      spec {
        container {
          name  = "tickets-mongo"
          image = "mongo"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "tickets_mongo_srv" {
  metadata {
    name = "tickets-mongo-srv"
  }

  spec {
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 27017
      target_port = "27017"
    }

    selector = {
      app = "tickets-mongo"
    }
  }
}

