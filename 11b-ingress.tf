resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress-externaldns-demo"
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name"           = "ingress-externaldns-demo"
      "alb.ingress.kubernetes.io/scheme"                       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                  = "ip"
      "alb.ingress.kubernetes.io/aws-load-balancer-attributes" = "load_balancing.cross_zone.enabled=true"
      "alb.ingress.kubernetes.io/healthcheck-protocol"         = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"                 = jsonencode([{ "HTTP" = 80 }, { "HTTPS" = 443 }, { "HTTP" = 3000 }])
      "alb.ingress.kubernetes.io/certificate-arn"              = "${aws_acm_certificate.acm_cert.arn}"
      "alb.ingress.kubernetes.io/ssl-redirect"                 = 443
      "alb.ingress.kubernetes.io/target-group-attributes"      = "stickiness.enabled=true"
      "external-dns.alpha.kubernetes.io/hostname"              = "throughone.click, www.throughone.click"
      "traffic.sidecar.istio.io/includeInboundPorts" : "3000, 80, 443"
      "nginx.ingress.kubernetes.io/service-upstream" : "true"
    }
  }
  spec {
    ingress_class_name = "alb" # Ingress Class            
    default_backend {
      service {
        name = kubernetes_service_v1.client_srv.metadata[0].name
        port {
          number = 3000
        }
      }
    }
    rule {
      host = "www.throughone.click"

      http {
        path {
          path      = "/api/payments/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.payments_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/users/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.auth_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/tickets/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.tickets_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/orders/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.orders_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.client_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }
      }
    }

    rule {
      host = "throughone.click"

      http {
        path {
          path      = "/api/payments/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.payments_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/users/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.auth_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/tickets/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.tickets_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/api/orders/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.orders_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.client_srv.metadata[0].name

              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}
