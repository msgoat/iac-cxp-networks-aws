provider "aws" {
  region  = var.region_name
  version = "~> 2.7"
}
locals {
  network_common_tags = {
    Organization = var.organization_name
    Department   = var.department_name
    Project      = var.project_name
    Stage        = var.stage
  }
}

# --- Network (VPC) ---------------------------

module "vpc" {
  source                = "../../modules/vpc"
  region_name           = var.region_name
  network_name          = var.network_name
  network_cidr          = var.network_cidr
  common_tags           = local.network_common_tags
  eks_cluster_name      = var.eks_cluster_name
}

# --- Network (Subnets) ---------------------------

data "aws_availability_zones" "zones_to_span" {
  state = "available"
}

locals {
  subnet_cidrs = cidrsubnets(var.network_cidr, 8, 8, 8, 4, 4, 4, 4, 4, 4)
  public_subnet_cidrs = slice(local.subnet_cidrs, 0, 3)
  private_subnet_cidrs = slice(local.subnet_cidrs, 3, 9)
}

module "subnets" {
  source = "../../modules/subnet_stacks"
  common_tags = local.network_common_tags
  eks_cluster_name = var.eks_cluster_name
  network_id = module.vpc.network_id
  network_name = var.network_name
  number_of_subnets_per_zone = 3
  public_subnets_per_zone = 1
  private_subnets_per_zone = 2
  zone_names = data.aws_availability_zones.zones_to_span.names
  public_subnet_cidrs = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  internet_gateway_id = module.vpc.internet_gateway_id
}
