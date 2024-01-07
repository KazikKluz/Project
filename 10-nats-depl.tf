resource "kubernetes_deployment_v1" "nats_depl" {

  metadata {
    name = "nats-depl"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "nats"
        fargate = "true"
      }
    }

    template {
      metadata {
        labels = {
          app     = "nats"
          fargate = "true"
        }
      }

      spec {
        container {
          name  = "nats"
          image = "nats-streaming:0.17.0"
          resources {
            limits = {
              cpu = "1000m"
            }
            requests = {
              cpu = "400m"
            }
          }
          args = ["-p", "4222", "-m", "8222", "-hbi", "5s", "-hbt", "5s", "-hbf", "2", "-SD", "-cid", "ticketing"]
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "nats_srv" {
  metadata {
    name = "nats-srv"
  }

  spec {
    port {
      name        = "tcp"
      protocol    = "TCP"
      port        = 4222
      target_port = "4222"
    }

    port {
      name        = "monitoring"
      protocol    = "TCP"
      port        = 8222
      target_port = "8222"
    }

    selector = {
      app = "nats"
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_nats" {
  metadata {
    name = "hpa-nats"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.nats_depl.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}

