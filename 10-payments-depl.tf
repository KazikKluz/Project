resource "kubernetes_deployment_v1" "payments_depl" {

  metadata {
    name = "payments-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "payments"
        fargate = "true"
      }
    }

    template {
      metadata {
        labels = {
          app     = "payments"
          fargate = "true"
        }
      }

      spec {
        container {
          name  = "payments"
          image = "x00192532/payments"
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
            value = "mongodb://payments-mongo-srv:27017/payments"
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

          env {
            name = "STRIPE_KEY"

            value_from {
              secret_key_ref {
                name = "stripe-secret"
                key  = "STRIPE_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "payments_srv" {
  metadata {
    name = "payments-srv"
  }

  spec {
    port {
      name        = "payments"
      protocol    = "TCP"
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "payments"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_payments" {
  metadata {
    name = "hpa-payments"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.payments_depl.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}

