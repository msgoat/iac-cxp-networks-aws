# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------
# Main entrypoint of this Terraform module.
# ----------------------------------------------------------------------------

provider "aws" {
  region  = var.region_name
  version = "~> 3.0"
}

# Local values used in this module
locals {
  module_common_tags = {
    Organization = var.organization_name
    Department   = var.department_name
    Project      = var.project_name
    Stage        = var.stage
  }
  subnet_cidrs = cidrsubnets(var.network_cidr, 8, 8, 8, 4, 4, 4, 4, 4, 4)
  public_web_subnet_cidrs = slice(local.subnet_cidrs, 0, 3)
  private_app_subnet_cidrs = slice(local.subnet_cidrs, 3, 6)
  private_data_subnet_cidrs = slice(local.subnet_cidrs, 6, 9)
  bastion_enabled = var.number_of_bastion_instances > 0 ? true : false
}

data "aws_region" "current" {

}

data "aws_availability_zones" "zones" {
  state = "available"
}
