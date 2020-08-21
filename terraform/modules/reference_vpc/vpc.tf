# vpc.tf
# Creates a new VPC in the specified region.

# --- VPC --------------------------------------------------------------------

# Create a VPC to launch our instances into
resource "aws_vpc" "vpc" {
  cidr_block = var.network_cidr
  # all public available instances should have DNS names
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(map("Name", "vpc-${var.region_name}-${lower(var.network_name)}"), local.module_common_tags)
}

