terraform {
  required_version = "~> 1.6.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }


  }

}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode("${aws_eks_cluster.eks_cluster.certificate_authority[0].data}")
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode("${aws_eks_cluster.eks_cluster.certificate_authority[0].data}")
    token                  = data.aws_eks_cluster_auth.cluster.token
  }

}

provider "kubectl" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode("${aws_eks_cluster.eks_cluster.certificate_authority[0].data}")
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}