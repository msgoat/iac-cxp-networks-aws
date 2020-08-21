output "network_id" {
  description = "Unique identifier of the newly created VPC network."
  value = module.vpc.network_id
}

output "public_subnet_ids" {
  description = "Unique identifier of all newly created public subnets."
  value = module.subnets.public_subnet_ids
}
