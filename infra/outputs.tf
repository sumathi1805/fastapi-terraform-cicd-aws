output "ec2_public_ip" {
  value = aws_instance.app_ec2.public_ip
}
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.app_sg.id
}
