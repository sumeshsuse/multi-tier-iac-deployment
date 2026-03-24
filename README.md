# Multi-tier Infrastructure Automation

This project was created as part of a take-home DevOps challenge.

The goal was to provision infrastructure using Terraform, configure servers using Ansible, deploy the application using Docker, and automate everything using GitHub Actions.

The setup supports two environments:

- dev
- prod

Each environment can be deployed independently.

---

## Project structure

terraform/
  dev/
  prod/
  modules/

ansible/
  playbooks/
  roles/

.github/workflows/

architectural-design-main/

Terraform is used for infrastructure provisioning, Ansible for configuration, and GitHub Actions for automation.

---

## Infrastructure

Terraform creates the following resources:

- API servers
- Database server
- Load balancer

Terraform modules are used to keep the code reusable.

Remote backend is configured using S3 and DynamoDB.

Example backend:

backend "s3" {
  bucket         = "multi-tier-terraform-state-q"
  key            = "dev/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-locks-q"
}

---

## Configuration with Ansible

After the servers are created, Ansible is used to configure them.

Tasks include:

- install Docker
- configure database
- deploy application using docker compose

Roles used:

roles/
  docker
  app
  db
  common

Main playbook:

ansible/playbooks/site.yml

---

## Application

The application is containerized.

Compose file:

ansible/roles/app/files/compose.yaml

---

## CI/CD

GitHub Actions is used to automate deployment.

Workflows:

Deploy Dev  
Deploy Prod  

Pipeline steps:

1. Configure backend credentials
2. Terraform init
3. Terraform apply
4. Generate inventory
5. Run Ansible
6. Verify service

Secrets are stored in GitHub Secrets.

---

## Variables

Example variable files:

terraform/dev/terraform.tfvars.example  
terraform/prod/terraform.tfvars.example  

Real tfvars are not committed.

---

## Notes

- Remote Terraform backend is used
- Separate state for dev and prod
- Modules are used
- Inventory is generated dynamically
- Secrets are not stored in repo

---

## Author

Sumesh Suseelan

