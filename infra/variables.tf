variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0532be01f26a3de55"  # replace with your AMI ID
}

variable "environment" {
  description = "Environment name (dev/prod)"
  default     = "dev"
}
