# variables.tf
# Module: bastion

variable "organization_name" {
  description = "The name of the organization that owns all AWS resources."
}

variable "department_name" {
  description = "The name of the department that owns all AWS resources."
}

variable "project_name" {
  description = "The name of the project that owns all AWS resources."
}

variable "stage" {
  description = "The name of the current environment stage."
}

variable "network_id" {
  description = "Unique identifier of the VPC that will own the stack."
}

variable "network_name" {
  description = "The name suffix of the VPC."
}

variable "public_subnet_ids" {
  description = "Unique identifiers of the public subnet supposed to host the Bastion EC2 instances."
  type = "list"
}

variable "common_tags" {
  description = "Common tags to be attached to each AWS resource"
  type = "map"
}

variable "bastion_ami_id" {
  description = "Unique identifier of the AMI to be used for the Bastion EC2 instances."
}

variable "bastion_instance_type" {
  description = "EC2 instance type to be used for the Bastion EC2 instances."
  default = "t3.micro"
}

variable "bastion_root_volume_type" {
  description = "Volume type of Bastion EC2 instances root volume."
  default = "standard"
}

variable "bastion_root_volume_size" {
  description = "Volume size in GB of Bastion EC2 instances root volume."
  default = "50"
}

variable "bastion_key_pair_name" {
  description = "Name of the SSH key pair name to be assigned to the Bastion EC2 instances."
}

variable "bastion_inbound_cidrs" {
  description = "The IP ranges in CIDR notation allowed to access the Bastion EC2 instances via SSH."
  type = "list"
}

variable "bastion_iam_instance_profile_name" {
  description = "The name of an IAM instance profile to be attached to all Bastion EC2 instances."
}

variable "bastion_group_desired_capacity" {
  description = "Desired number of Bastion EC2 instances which should be always available"
  default = "1"
}

variable "bastion_group_min_capacity" {
  description = "Minimum number of Bastion EC2 instances which should be always available"
  default = "1"
}

variable "bastion_group_max_capacity" {
  description = "Maximum number of Bastion EC2 instances which should be always available"
  default = "1"
}
