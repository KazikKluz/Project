resource "kubernetes_deployment_v1" "orders_depl" {

  metadata {
    name = "orders-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "orders"
        "fargate" = "true"

      }
    }

    template {
      metadata {
        labels = {
          app       = "orders"
          "fargate" = "true"
        }
      }

      spec {
        container {
          name  = "orders"
          image = "x00192532/orders"
          resources {
            limits = {
              cpu = "1000m"
            }
            requests = {
              cpu = "400m"
            }
          }

          env {
            name = "NATS_CLIENT_ID"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "NATS_URL"
            value = "http://nats-srv:4222"
          }

          env {
            name  = "NATS_CLUSTER_ID"
            value = "ticketing"
          }

          env {
            name  = "MONGO_URI"
            value = "mongodb://orders-mongo-srv:27017/orders"
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

resource "kubernetes_service_v1" "orders_srv" {
  metadata {
    name = "orders-srv"
  }

  spec {
    port {
      name        = "orders"
      protocol    = "TCP"
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "orders"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_orders" {
  metadata {
    name = "hpa-orders"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.orders_depl.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}
