# main.tf

# Local values used in this module
locals {
  bastion_common_tags = merge(var.common_tags)
  bastion_name    = lower(var.network_name)
}

# Retrieve information about the specified VPC
data "aws_vpc" "vpc" {
  id = var.network_id
}

# Retrieve information about the current Region
data "aws_region" "current" {}

# --- Bastion Instance Launch Configuration --------------------------------------

resource "aws_launch_configuration" "bastion" {
  associate_public_ip_address = true
  iam_instance_profile = var.bastion_iam_instance_profile_name
  image_id = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  name_prefix = "ec2-${data.aws_region.current.name}-${var.network_name}-bastion-"
  security_groups = [aws_security_group.bastion_security_group.id]
  key_name = var.bastion_key_pair_name
  root_block_device {
    volume_type = var.bastion_root_volume_type
    volume_size = var.bastion_root_volume_size
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- Worker Nodes AutoScaling Group -----------------------------------------

resource "aws_autoscaling_group" "bastion" {
  desired_capacity = var.bastion_group_desired_capacity
  launch_configuration = aws_launch_configuration.bastion.id
  max_size = var.bastion_group_max_capacity
  min_size = var.bastion_group_min_capacity
  name = "asg-${data.aws_region.current.name}-${var.network_name}-bastion"
  vpc_zone_identifier = var.public_subnet_ids
  tag {
    key = "Organization"
    value = var.organization_name
    propagate_at_launch = true
  }
  tag {
    key = "Department"
    value = var.department_name
    propagate_at_launch = true
  }
  tag {
    key = "Project"
    value = var.project_name
    propagate_at_launch = true
  }
  tag {
    key = "Stage"
    value = var.stage
    propagate_at_launch = true
  }
  tag {
    key = "Role"
    value = "bastion"
    propagate_at_launch = true
  }
}

# Security group for bastion instance
resource "aws_security_group" "bastion_security_group" {
  name        = "sec-${data.aws_region.current.name}-${var.network_name}-bastion"
  description = "Controls all inbound and outbound traffic passed through the bastion instances"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_inbound_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # from here we have to connect to anything within this region
  }
  tags = merge(map(
    "Name", "sg-${data.aws_region.current.name}-${var.network_name}-bastion"
  ), local.bastion_common_tags)
}
