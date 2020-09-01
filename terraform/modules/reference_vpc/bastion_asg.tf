# bastion_asg.tf
# ----------------------------------------------------------------------------
# Creates an auto scaling group with the requested number of bastion instances
# ----------------------------------------------------------------------------

# Local values used in this module
locals {
  bastion_name    = lower(var.network_name)
}

# creates an auto scaling group that ensures the availability of the requested number of bastion instances
resource "aws_autoscaling_group" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  desired_capacity = var.number_of_bastion_instances
  launch_template {
    id = aws_launch_template.bastion[count.index].id
  }
  max_size = var.number_of_bastion_instances
  min_size = var.number_of_bastion_instances
  name = "asg-${data.aws_region.current.name}-${var.network_name}-bastion"
  vpc_zone_identifier = aws_subnet.public_web_subnets.*.id
  tags = [for k, v in merge(map("Role", "bastion"), local.module_common_tags) : map("key", k, "value", v, "propagate_at_launch", "true")]
}

# create a launch template for bastion instances
resource "aws_launch_template" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  name = "lt-${data.aws_region.current.name}-${var.network_name}-bastion"
  description = "Defines instances to be managed by bastion auto scaling group"
  iam_instance_profile {
    arn = aws_iam_instance_profile.bastion[count.index].arn
  }
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.bastion_instance_type
  image_id = data.aws_ami.bastion.id
  key_name = var.bastion_key_name
  vpc_security_group_ids = [aws_security_group.bastion[count.index].id]
  tag_specifications {
    resource_type = "instance"
    tags = merge(map(
      "Name", "ec2-${data.aws_region.current.name}-${var.network_name}-bastion",
      "Role", "bastion"),
    local.module_common_tags)
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(map(
    "Name", "ebs-${data.aws_region.current.name}-${var.network_name}-bastion",
    "Role", "bastion"),
    local.module_common_tags)
  }
  tags = merge(map("Role", "bastion"), local.module_common_tags)
}

# retrieve the latest AMI version used for all bastion instances
# @TODO: use custom hardened AMI based on Amazon Linux 2
data "aws_ami" "bastion" {
  owners = ["137112412989"]
#  executable_users = ["self"]
  most_recent = "true"
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for bastion instance
resource "aws_security_group" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  name        = "sec-${data.aws_region.current.name}-${var.network_name}-bastion"
  description = "Controls all inbound and outbound traffic passed through the bastion instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = length(var.bastion_inbound_traffic_cidrs) > 0 ? var.bastion_inbound_traffic_cidrs : var.inbound_traffic_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # from here we have to connect to anything within this region
  }
  tags = merge(map(
  "Name", "sg-${data.aws_region.current.name}-${var.network_name}-bastion"
  ), local.module_common_tags)
}
