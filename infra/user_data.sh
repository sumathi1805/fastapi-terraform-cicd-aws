#!/bin/bash
yum install -y docker
systemctl start docker

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/app
cd /opt/app

# get secrets
aws ssm get-parameter --name /fastapi_app/nysqluser --with-decryption --query Parameter.Value --output text > .env
aws ssm get-parameter --name /fastapi_app/mysqlpasswd --with-decryption --query Parameter.Value --output text >> .env
aws ssm get-parameter --name /fastapi_app/mysqldb --with-decryption --query Parameter.Value --output text >> .env

docker compose -f docker-compose.runtime.yml pull
docker compose -f docker-compose.runtime.yml up -d

