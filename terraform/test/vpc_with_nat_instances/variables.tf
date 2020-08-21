variable "region_name" {
  description = "The AWS region to deploy into (e.g. eu-central-1)."
}

variable "organization_name" {
  description = "The name of the organization that owns all AWS resources."
}

variable "department_name" {
  description = "The name of the department that owns all AWS resources."
}

variable "project_name" {
  description = "The name of the project that owns all AWS resources."
}

variable "stage" {
  description = "The name of the current environment stage."
}

variable "network_name" {
  description = "The name suffix of the VPC."
}

variable "network_cidr" {
  description = "The CIDR range of the VPC."
}

variable "eks_cluster_name" {
  description = "AWS EKS cluster name to annotate VPC and subnets"
  default = ""
}
