# variables.tf

variable "common_tags" {
  description = "Common tags to be attached to each AWS resource"
  type = "map"
}

variable "network_name" {
  description = "The name suffix of the VPC."
}
