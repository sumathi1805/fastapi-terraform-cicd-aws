terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "terraform-state-bucket-us-east-1"       # replace with your S3 bucket
    key            = "fastapi/terraform.tfstate"
    region         = "us-east-1"
  }
}



provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "app_sg" {
  name_prefix = "fastapi-sg-"          # avoids duplicate name error
  description = "Security group for FastAPI app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_instance_profile" "existing_profile" {
  name = "ec2roleforcodedeploy_cicd"  # usually same as role name
}

# Data resource to check if EC2 exists
data "aws_instances" "existing_ec2" {
  filter {
    name   = "tag:Name"
    values = ["FastAPI-Docker-EC2"]
  }
}

resource "aws_instance" "app_ec2" {
  count = length(data.aws_instances.existing_ec2.ids) > 0 ? 0 : 1
  ami                    = var.ami_id
  instance_type          = "t3a.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile = data.aws_iam_instance_profile.existing_profile.name

  user_data = file("user_data.sh")

  tags = {
    Name = "FastAPI-Docker-EC2"
    Env  = var.environment
  }
}

