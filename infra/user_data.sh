#!/bin/bash
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Docker Compose (v2)
curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
