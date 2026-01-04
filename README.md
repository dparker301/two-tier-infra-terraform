Two-Tier Infrastructure Foundation (Terraform)

Project 1 — Terraform AWS Foundation for a Two-Tier Flask Application

This project builds a reusable AWS baseline that will support Projects 2–6, including CI/CD, configuration management, and application deployment.
Overview

This repository provisions a secure, production-style two-tier AWS environment using Terraform, designed to serve as the foundation for a Flask application and Jenkins-based CI/CD pipeline.

What this project delivers

Remote Terraform state with locking

Network isolation using public and private subnets

Secure access patterns (least privilege)

Outputs consumable by Ansible and Jenkins


Architecture Summary

Tier 1 (Public):

Jenkins EC2 (Ubuntu)

SSH and Jenkins UI access restricted to your IP

Tier 2 (Private):

RDS MySQL instance

No public access

Database access restricted to Jenkins security group

State & Control:

Terraform state stored in S3

State locking via DynamoDB


                   +------------------------+
                   |   Terraform State      |
                   |  S3 + DynamoDB (Lock)  |
                   +------------------------+

                           AWS Region
                                |
+------------------------------------------------------------------+
| VPC 10.10.0.0/16                                                   |
|                                                                  |
|  +----------------------+      +------------------------+        |
|  | Public Subnet (AZ-a) |      | Private Subnet (AZ-a) |        |
|  | 10.10.10.0/24        |      | 10.10.20.0/24         |        |
|  |                      |      |                        |        |
|  | Jenkins EC2 (Ubuntu) | ---> | RDS MySQL (Private)   |        |
|  | SG: 22, 8080 (MY IP) |      | SG: 3306 (Jenkins SG)|        |
|  +----------------------+      +------------------------+        |
|                                                                  |
|  +----------------------+      +------------------------+        |
|  | Public Subnet (AZ-b) |      | Private Subnet (AZ-b) |        |
|  | 10.10.11.0/24        |      | 10.10.21.0/24         |        |
|  +----------------------+      +------------------------+        |
|                                                                  |
|  Internet Gateway (IGW)                                           |
|  - Public route: 0.0.0.0/0 → IGW                                  |
|  - Private route: No NAT (intentional for Project 1)             |
+------------------------------------------------------------------+


| Component       | Rule                                       |
| --------------- | ------------------------------------------ |
| SSH             | Allowed only from `MY_IP/32`               |
| Jenkins (8080)  | Allowed only from `MY_IP/32`               |
| MySQL (3306)    | Allowed only from Jenkins Security Group   |
| RDS             | No public access                           |
| Private Subnets | No outbound internet (no NAT in Project 1) |


Repository Structure

two_tier_infra_terraform/
├── backend.tf            # Remote state backend (S3 + DynamoDB)
├── versions.tf           # Terraform & provider constraints
├── providers.tf          # AWS provider + default tags
├── variables.tf          # Input variables (env-agnostic)
├── locals.tf             # Naming conventions + common tags
├── main.tf               # Root module wiring
├── outputs.tf            # Exposed outputs for downstream use
├── README.md

├── env/
│   ├── dev.tfvars        # Active environment
│   └── prod.tfvars       # Planned (not applied yet)

├── keys/                 # Project-scoped SSH keys (gitignored)
│   ├── two-tier-dev-key
│   └── two-tier-dev-key.pub

├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf       # Jenkins EC2 + SG + key pair
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── rds/
│       ├── main.tf       # Private RDS MySQL + SG
│       ├── variables.tf
│       └── outputs.tf

└── bootstrap/
    ├── main.tf           # One-time S3 + DynamoDB setup
    ├── providers.tf
    ├── variables.tf
    └── outputs.tf
