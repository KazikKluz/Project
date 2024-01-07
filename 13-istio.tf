# resource "kubernetes_namespace_v1" "istio_system" {
#     depends_on = [ aws_eks_node_group.eks_ng_private ]

#   metadata {
#     annotations = {
#       name = "istio-system"
#     }


#     name = "istio-system"
#   }
# }

# module "istio" {
#   source  = "sepulworld/istio/helm"
#   version = "0.0.3"
#   # insert the 1 required variable here
#   cluster_name = aws_eks_cluster.eks_cluster.name
# }

resource "null_resource" "injection_enabled" {

  depends_on = [null_resource.context_update]
  provisioner "local-exec" {
    command = "kubectl label namespace default istio-injection=enabled"
  }
}

resource "null_resource" "istio" {

  depends_on = [null_resource.injection_enabled]
  provisioner "local-exec" {
    command = "istioctl install -y"
  }
}

resource "null_resource" "istio-addons" {

  depends_on = [null_resource.istio]
  provisioner "local-exec" {
    command = "kubectl apply -f ./addons"

  }

  provisioner "local-exec" {
    command = "kubectl delete -f ./addons"
    when    = destroy
  }

}