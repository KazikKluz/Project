# # provider "time" {

# # }

# # resource "time_sleep" "wait_60_seconds" {
# #   depends_on      = [aws_acm_certificate.acm_cert]
# #   create_duration = "60s"
# # }

# resource "kubernetes_ingress_v1" "ingress_srv" {


#   metadata {
#     name = "ingress-srv"

#     annotations = {

#       "nginx.ingress.kubernetes.io/use-regex"       = "true"
#       "nginx.ingress.kubernetes.io/listen-ports"    = jsonencode([{ "HTTPS" = 443 }, { "HTTP" = 80 }])
#       "nginx.ingress.kubernetes.io/certificate-arn" = "${aws_acm_certificate.acm_cert.arn}"
#       "external-dns.alpha.kubernetes.io/hostname"   = "www.throughone.click"

#     }
#   }

#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       host = "www.throughone.click"

#       http {
#         path {
#           path      = "/api/payments/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "payments-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/users/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "auth-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/tickets/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "tickets-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/orders/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "orders-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "client-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }
#       }
#     }

#     rule {
#       host = "throughone.click"

#       http {
#         path {
#           path      = "/api/payments/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "payments-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/users/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "auth-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/tickets/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "tickets-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/api/orders/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "orders-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }

#         path {
#           path      = "/?(.*)"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "client-srv"

#               port {
#                 number = 3000
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

