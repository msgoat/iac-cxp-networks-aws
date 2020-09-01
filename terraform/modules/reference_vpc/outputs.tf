output "vpc_id" {
  description = "Unique identifier of the newly created VPC network."
  value = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "Fully qualified name of the newly created VPC network."
  value = aws_vpc.vpc.tags["Name"]
}

output "bastion_security_group_name" {
  description = "Name of the security group applied to all bastion instances."
  value = local.bastion_enabled ? aws_security_group.bastion[0].name : ""
}
