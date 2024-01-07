resource "kubernetes_deployment_v1" "auth_depl" {
  depends_on = [null_resource.istio]
  metadata {
    name = "auth-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth"
        #     fargate = "true"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth"
          #      fargate = "true"

        }
      }

      spec {
        container {
          name  = "auth"
          image = "x00192532/auth"
          resources {
            limits = {
              cpu = "1000m"
            }
            requests = {
              cpu = "400m"
            }
          }

          env {
            name  = "MONGO_URI"
            value = "mongodb://auth-mongo-srv:27017/auth"
          }

          env {
            name = "JWT_KEY"

            value_from {
              secret_key_ref {
                name = "jwt-secret"
                key  = "JWT_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "auth_srv" {

  metadata {
    name = "auth-srv"
  }

  spec {
    port {
      name        = "auth"
      protocol    = "TCP"
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "auth"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_auth" {
  metadata {
    name = "hpa-auth"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.auth_depl.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}

