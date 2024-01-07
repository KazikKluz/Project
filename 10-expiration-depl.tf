resource "kubernetes_deployment_v1" "expiration_depl" {

  metadata {
    name = "expiration-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "expiration"
        fargate = "true"
      }
    }

    template {
      metadata {
        labels = {
          app     = "expiration"
          fargate = "true"

        }
      }

      spec {
        container {
          name  = "expiration"
          image = "x00192532/expiration"
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
            name  = "REDIS_HOST"
            value = "expiration-redis-srv"
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_expiration" {
  metadata {
    name = "hpa-expiration"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.expiration_depl.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}

