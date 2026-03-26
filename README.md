# FastAPI CI/CD Project on AWS (Terraform + Docker + CodePipeline)
This project demonstrates a production-style CI/CD pipeline for a FastAPI application using AWS-native services, fully automated infrastructure provisioning with Terraform, containerization with Docker, and secure deployment behind an Application Load Balancer (ALB).
## Architecture Overview
              GitHub
              │ (push)
              ▼
              AWS CodePipeline
              │
              ├── Infra Build (CodeBuild)
              │     └── Terraform: EC2, S3, IAM Role, Security Group
              │
              ▼
              ├── App Build (CodeBuild)
              │     └── Build Docker image(FastApi) & push to Docker Hub
              │
              ▼
              └── App Deploy (CodeBuild)
                    └── Deploy container on EC2 using SSM

            User → ALB → EC2 (FastAPI on Docker) → MySQL

## Technology used

      Cloud Provider     --------->	 AWS
      IaC	               --------->  Terraform
      CI/CD	             --------->  AWS CodePipeline, CodeBuild
      Source Control     --------->	 GitHub (GitHub App connection)
      Containerization   --------->	 Docker, Docker Compose
      Backend	           --------->  FastAPI (Python)
      Database           --------->  MySQL (Docker)
      Networking         --------->  VPC, ALB, Security Groups
      OS	               --------->  Amazon Linux 2

## Security Highloghts

  * IAM least-privilege roles for CodeBuild and CodePipeline
  * Secrets stored in AWS SSM Parameter Store
  * No hardcoded credentials in code
  * ALB exposes only ports 80/443
  * Application port 8000 remains private
    
## Repository Structure

              .
              ├── app/
              │   ├── main.py
              │   ├── requirements.txt
              │   |── Dockerfile
              │   |── docker-compose.ci.yml
              |   |-- docker-compose.runtime.yml
              |   |-- db.py
              │
              ├── infra/
              │   ├── main.tf
              │   ├── variables.tf
              │   ├── outputs.tf
              │   └── userdata.sh
              │
              ├── buildspec-infra.yml
              ├── buildspec-app.yml
              ├── buildspec-app-deploy.yml
              │
              └── README.md

## CI/CD Pipeline Stages
### 1. Source Stage (GitHub)
* GitHub repository connected via AWS CodeConnections (GitHub App)
* Pipeline triggered manually or on commit (optional)

### 2. Infrastructure Build (Terraform)

### Provisions:
          * EC2 instance
          * IAM Role
          * Security Group
          * S3
Terraform runs inside CodeBuild using a dedicated buildspec file.
Terraform plan and apply executed in CodeBuild
Creates or updates AWS networking, compute, and IAM resources
### 3. Application Build
      * Builds FastAPI Docker image
      * Tags image with latest
      * Pushes image to Docker Hub
### 4. Application Deploy
      * Pulls latest Docker image on EC2
      * Runs application using Docker Compose
      * Zero manual SSH required      
### 5. Deployment Flow Summary
      * Developer pushes code to GitHub
      * CodePipeline executes automatically (or manually)
      * Infrastructure is provisioned/updated
      * Application image is built and pushed
      * EC2 pulls and runs latest container
### 6. Learning Outcomes
      * Real-world CI/CD pipeline design
      * Terraform for production infrastructure
      * Secure secret management
      * Dockerized microservice deployment
      * IAM least-privilege implementation
### 7. Scalability & Extensibility
      * HTTPS using ACM
      * AWS WAF integration
      * Auto Scaling Group
      * CloudWatch alarms & logging
      * Blue/Green deployments
      * RDS instead of containerized MySQL
      
## ⚠️ Challenges & Learnings

### Challenges
- Integrating Docker build process with AWS CodePipeline
- Managing IAM roles and permissions for CI/CD services
- Debugging deployment failures in CodeBuild and pipeline stages

### Learnings
- Learned end-to-end CI/CD pipeline setup on AWS
- Gained experience in containerizing applications using Docker
- Improved understanding of automated deployments and pipeline workflows

  


  
