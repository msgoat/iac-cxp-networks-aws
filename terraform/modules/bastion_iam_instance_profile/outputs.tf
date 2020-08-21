# outputs.tf

output "profile_id" {
  description = "Unique identifier of the Bastion EC2 instance profile"
  value = "${aws_iam_instance_profile.bastion.id}"
}

output "profile_arn" {
  description = "ARN of the Bastion EC2 instance profile"
  value = "${aws_iam_instance_profile.bastion.arn}"
}

output "profile_name" {
  description = "Name of the Bastion EC2 instance profile"
  value = "${aws_iam_instance_profile.bastion.name}"
}
