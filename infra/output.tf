# EC2 Instance ID
output "ec2_instance_id" {
  value = aws_instance.app_ec2.id
}

# EC2 Public IP
output "ec2_public_ip" {
  value = aws_instance.app_ec2.public_ip
}

# Security Group ID
output "security_group_id" {
  value = aws_security_group.app_sg.id
}
