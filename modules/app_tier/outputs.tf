output "security_group_id" {
  description = "id of app security group"
  value = "${aws_security_group.app_sg.id}"
}

output "subnet_cidr_block" {
  description = "the cidr_block of the app subnet"
  value = "${aws_subnet.app_subnet.cidr_block}"
}

output "aws_instance_id" {
  description = "the aws app instance_id"
  value = "${aws_instance.app_instance.id}"
}
