# bastion_iam.tf
# ----------------------------------------------------------------------------
# Create all IAM artifacts required for Bastion EC2 instances
# ----------------------------------------------------------------------------

# EC2 instance profile for Bastion instances
resource "aws_iam_instance_profile" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  name = "profile-${data.aws_region.current.name}-${var.network_name}-bastion"
  role = aws_iam_role.bastion[count.index].name
}

# IAM role that allows the EC2 instance to assume this role
resource "aws_iam_role" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  name = "role-${data.aws_region.current.name}-${var.network_name}-bastion"
  description = "Grants bastion EC2 instances only minimum access to AWS services"
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
  tags = local.module_common_tags
}

# create policy that allows access to a S3 bucket with public keys
# @TODO replace with template_file datasource to have configurable bucket names
resource "aws_iam_role_policy" "bastion" {
  count = local.bastion_enabled ? 1 : 0
  name = "policy-${data.aws_region.current.name}-${var.network_name}-bastion"
  role = aws_iam_role.bastion[count.index].id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicKeysBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::public-keys/*"
        }
    ]
  }
  EOF
}
