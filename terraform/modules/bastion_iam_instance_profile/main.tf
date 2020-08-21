# main.tf

# Local values used in this module
locals {
  iam_common_tags = merge(var.common_tags)
}

# Retrieve information about the current Region
data "aws_region" "current" {}

# EC2 instance profile for Bastion instances
resource "aws_iam_instance_profile" "bastion" {
  name = "profile-${data.aws_region.current.name}-${var.network_name}-bastion"
  role = aws_iam_role.bastion.name
}

# IAM role that allows the EC2 instance to assume this role
resource "aws_iam_role" "bastion" {
  name = "role-${data.aws_region.current.name}-${var.network_name}-bastion"
  description = "Grants bastion EC2 instances administrator access to AWS services"
  path = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = local.iam_common_tags
}

# Policy attachment which attaches managed policy AdministratorAccess to the Bastion IAM role
resource "aws_iam_role_policy_attachment" "bastion" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role = aws_iam_role.bastion.name
}
