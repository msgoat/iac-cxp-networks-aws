# subnets.tf
# Creates a fixed set of subnets in each availability zone.
#

# create a public web subnet in each availability zone
resource "aws_subnet" "public_web_subnets" {
  count = length(data.aws_availability_zones.zones.names)
  vpc_id = aws_vpc.vpc.id
  cidr_block = local.public_web_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(map("Name", "subnet-${data.aws_availability_zones.zones.names[count.index]}-${var.network_name}-web"), local.module_common_tags)
}

# create a private application subnet in each availability zone
resource "aws_subnet" "private_app_subnets" {
  count = length(data.aws_availability_zones.zones.names)
  vpc_id = aws_vpc.vpc.id
  cidr_block = local.private_app_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(map("Name", "subnet-${data.aws_availability_zones.zones.names[count.index]}-${var.network_name}-app"), local.module_common_tags)
}

# create a private datastore subnet in each availability zone
resource "aws_subnet" "private_data_subnets" {
  count = length(data.aws_availability_zones.zones.names)
  vpc_id = aws_vpc.vpc.id
  cidr_block = local.private_data_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(map("Name", "subnet-${data.aws_availability_zones.zones.names[count.index]}-${var.network_name}-data"), local.module_common_tags)
}
