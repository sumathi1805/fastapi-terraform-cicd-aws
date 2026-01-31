# EC2 Instance ID
output "ec2_instance_id" {
  value = length(aws_instance.app_ec2) > 0 ? aws_instance.app_ec2[0].id : data.aws_instances.existing_ec2.ids[0]
}

# EC2 Public IP
output "ec2_public_ip" {
  value = length(aws_instance.app_ec2) > 0 ? aws_instance.app_ec2[0].public_ip : data.aws_instance.existing_ec2_info[0].public_ip
}

# Security Group ID
output "security_group_id" {
  value = aws_security_group.app_sg.id
}
