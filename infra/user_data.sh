#!/bin/bash
set -e

# ---------- System ----------
yum update -y
yum install -y docker awscli unzip
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# ---------- Docker Compose v2 ----------
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ---------- SSM Agent ----------
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# ---------- App directory ----------
mkdir -p /opt/app
chown -R ec2-user:ec2-user /opt/app
cd /opt/app

# ---------- Fetch secrets from SSM ----------
MYSQL_USER=$(aws ssm get-parameter --name /fastapi_app/nysqluser --with-decryption --query Parameter.Value --output text)
MYSQL_PASSWORD=$(aws ssm get-parameter --name /fastapi_app/mysqlpasswd --with-decryption --query Parameter.Value --output text)
MYSQL_DATABASE=$(aws ssm get-parameter --name /fastapi_app/mysqldb --with-decryption --query Parameter.Value --output text)
DOCKER_USER=$(aws ssm get-parameter --name /fastapi_app/dockeruser --with-decryption --query Parameter.Value --output text)

# ---------- Create .env ----------
cat <<EOF > .env
IMAGE_TAG=stable
DOCKER_USER=$DOCKER_USER
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD
MYSQL_DATABASE=$MYSQL_DATABASE
EOF

chmod 600 .env
chown ec2-user:ec2-user .env

# ---------- Create docker-compose file ----------
cat <<'EOF' > docker-compose.runtime.yml
version: "3.9"

services:
  mysql-db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
    volumes:
      - mysql-data:/var/lib/mysql

  fastapi-app:
    image: ${DOCKER_USER}/fastapi-app:${IMAGE_TAG}
    environment:
      DB_HOST: mysql-db
      DB_USER: ${MYSQL_USER}
      DB_PASS: ${MYSQL_PASSWORD}
      DB_NAME: ${MYSQL_DATABASE}
    ports:
      - "8000:8000"
    depends_on:
      - mysql-db

volumes:
  mysql-data:
EOF

# ---------- Start containers ----------
docker compose -f docker-compose.runtime.yml pull
docker compose -f docker-compose.runtime.yml up -d
