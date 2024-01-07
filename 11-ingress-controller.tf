# resource "kubernetes_namespace_v1" "ingress_nginx" {

#   metadata {
#     annotations = {
#       name = "ingress-nginx"
#     }


#     name = "ingress-nginx"
#   }
# }

# resource "helm_release" "ingress_nginx" {
#   name = "ingress-nginx"

#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

# }


# Datasource
# data "http" "get_contoller_config" {
#   # Optional request headers
#   url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml"
#   request_headers = {
#     Accept = "text/*"
#   }
# }

# # Datasource: kubectl_file_documents 
# # This provider provides a data resource kubectl_file_documents to enable ease of splitting multi-document yaml content.
# data "kubectl_file_documents" "contoroller_docs" {
#   content = data.http.get_contoller_config.body
# }

# resource "null_resource" "context_update" {

#   depends_on = [kubernetes_namespace_v1.ingress_nginx]
#   provisioner "local-exec" {
#     command = "aws eks --region eu-west-1 update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
#   }
# }

# # Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
# resource "kubectl_manifest" "conroller_deployment" {

#   depends_on = [null_resource.context_update]
#   for_each   = data.kubectl_file_documents.contoroller_docs.manifests
#   yaml_body  = each.value
# }