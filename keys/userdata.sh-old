#!/bin/bash
set -e

# Update system and install Docker
yum update -y
yum install -y docker awscli
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Docker Compose v2 plugin
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ---------- Install AWS CLI v2 (for SSM) ----------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create app directory
mkdir -p /opt/app
chown -R ec2-user:ec2-user /opt/app

# ---------- Enable SSM Agent ----------
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent


: <<'BLOCK'
cd /opt/app

# Create .env file from SSM (dynamic, NOT in GitHub)
echo "MYSQL_USER=$(aws ssm get-parameter --name /fastapi_app/mysqluser --with-decryption --query Parameter.Value --output text)" > .env
echo "MYSQL_PASSWORD=$(aws ssm get-parameter --name /fastapi_app/mysqlpasswd --with-decryption --query Parameter.Value --output text)" >> .env
echo "MYSQL_DATABASE=$(aws ssm get-parameter --name /fastapi_app/mysqldb --with-decryption --query Parameter.Value --output text)" >> .env

# Optionally add Docker Hub creds if needed for private images
echo "DOCKER_USER=$(aws ssm get-parameter --name /fastapi_app/dockeruser --with-decryption --query Parameter.Value --output text)" >> .env
echo "DOCKER_PASSWORD=$(aws ssm get-parameter --name /fastapi_app/docker_passwd --with-decryption --query Parameter.Value --output text)" >> .env

chmod 600 .env  # secure the file

# Pull & start containers
docker compose -f docker-compose.runtime.yml pull
docker compose -f docker-compose.runtime.yml up -d
BLOCK
