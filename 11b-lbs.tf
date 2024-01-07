data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.body
}

resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "${local.name}-AmazonLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "LLB IAM Policy"
  policy      = data.http.lbc_iam_policy.body
}

output "ebs_csi_iam_policy_arn" {
  value = aws_iam_policy.lbc_iam_policy.arn
}

resource "aws_iam_role" "lbc_iam_role" {
  name = "${local.name}-lbc-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }

      },
    ]
  })

  tags = {
    tag-key = "${local.name}-AWSLoadBalancerControllerIAMPolicy"
  }
}

resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role       = aws_iam_role.lbc_iam_role.name
}

output "lbc_iam_role_arn" {
  description = "LBC Role ARN"
  value       = aws_iam_role.lbc_iam_role.arn
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = data.terraform_remote_state.eks.outputs.cluster_id
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
#     cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role.lbc_iam_role]
  name       = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"

  # this changes based on your region
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lbc_iam_role.arn
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks_cluster.id
  }
}

output "lbc_helm_metadata" {
  description = "metadata block outlining the status of the release"
  value       = helm_release.loadbalancer_controller.metadata
}

resource "null_resource" "context_update" {

  depends_on = [aws_eks_node_group.eks_ng_private]
  provisioner "local-exec" {
    command = "aws eks --region eu-west-1 update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
  }
}