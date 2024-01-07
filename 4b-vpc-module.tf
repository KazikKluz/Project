# AWS Availability Zones Datasource
data "aws_availability_zones" "available" {
  # state = "available"
}

# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  # VPC Basic Details
  name = "${local.name}-${var.vpc_name}"
  cidr = var.vpc_cidr_block
  # azs             = var.vpc_availability_zones
  azs                     = data.aws_availability_zones.available.names
  private_subnets         = var.vpc_private_subnets
  public_subnets          = var.vpc_public_subnets
  map_public_ip_on_launch = true

  # NAT Gateway - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags     = local.common_tags
  vpc_tags = local.common_tags

  # Additional Tags to Subnets


  public_subnet_tags = {
    Type                                              = "public-subnets"
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  private_subnet_tags = {
    Type                                              = "private-subnets"
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }
}