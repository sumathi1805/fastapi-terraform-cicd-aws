provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "app_key" {
  key_name   = "fastapi-terraform"
  public_key = file("${path.module}/keys/fastapi_key.pub")
}

resource "aws_security_group" "app_sg" {
  name = "fastapi-sg"

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

resource "aws_instance" "app_ec2" {
  ami                    = var.ami_id
  instance_type          = "t3a.micro"
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "FastAPI-Docker-EC2"
  }
}

