resource "kubernetes_deployment_v1" "client_depl" {
  # depends_on = [aws_eks_fargate_profile.fargate_profile]
  metadata {
    name = "client-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client"
        #fargate = "true"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
          # fargate = "true"

        }
      }

      spec {
        container {
          name  = "client"
          image = "x00192532/client"
          resources {
            limits = {
              cpu = "1000m"
            }
            requests = {
              cpu = "400m"
            }
          }
        }

      }
    }
  }
}

resource "kubernetes_service_v1" "client_srv" {
  metadata {
    name = "client-srv"
  }

  spec {
    port {
      name        = "client"
      protocol    = "TCP"
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "client"
    }
  }
}



