variable "cluster_name" {
  description = "Name of the EKS Cluster. Prefix in names of related resources"
  type        = string
  default     = "eksdemo"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint should be available"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates wheter or nor the Amazon EKS public API server endpoint should be available"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}