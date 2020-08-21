output "vpc_id" {
  description = "Unique identifier of the newly created VPC network."
  value = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "Fully qualified name of the newly created VPC network."
  value = aws_vpc.vpc.tags["Name"]
}
