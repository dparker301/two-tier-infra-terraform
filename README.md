Project 1 = Terraform AWS Foundation for your Two-Tier Flask app

Building an AWS baseline that you can reuse for Projects 2–6:

    1. Remote state (S3 + DynamoDB)
    2. VPC (public + private subnets)
    3. Security groups
    4. EC2 Jenkins host (public)
    5. RDS MySQL (private)
    6. Outputs you’ll feed into Ansible and Jenkins

Project 1 Architecture

    Public subnet
    Jenkins EC2 (Ubuntu)
    (Optional later) ALB
    Private subnets
    RDS MySQL
    Security
    SSH only from your IP
    Jenkins 8080 only from your IP
    RDS 3306 only from Jenkins SG (or later ECS/App SG)


Build out diagram

two_tier_infra_terraform/
├── backend.tf                 # Remote state backend (S3 + DynamoDB)
├── versions.tf                # Terraform & provider version constraints
├── providers.tf               # AWS provider + default tags
├── variables.tf               # Input variables (env-agnostic)
├── locals.tf                  # Naming + common tags (best practice)
├── main.tf                    # Root module wiring (VPC, EC2, RDS)
├── outputs.tf                 # Exposed outputs (IP, endpoints, IDs)
├── README.md                  # Project 1 documentation
│
├── env/                        # Environment-specific variables
│   ├── dev.tfvars
│   └── prod.tfvars             # (planned, not applied yet)
│
├── keys/                       # Project-scoped SSH keys (gitignored)
│   ├── two-tier-dev-key
│   └── two-tier-dev-key.pub
│
├── modules/                    # Reusable Terraform modules
│   ├── vpc/
│   │   ├── main.tf             # VPC, subnets, routing
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ec2/
│   │   ├── main.tf             # Jenkins EC2 + SG + key pair
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── rds/
│       ├── main.tf             # Private RDS MySQL + SG
│       ├── variables.tf
│       └── outputs.tf
│
└── bootstrap/                  # ONE-TIME Terraform backend setup
    ├── main.tf                 # S3 bucket + DynamoDB table
    ├── variables.tf
    ├── providers.tf
    └── outputs.tf


Project 1 — Two-Tier Foundation (Terraform)
===========================================
                      +-------------------+
                       |   Terraform State |
                       |  S3 + DynamoDB    |
                       +-------------------+

                              AWS Region
                                  |
+------------------------------------------------------------------+
|                             VPC 10.10.0.0/16                     |
|                                                                  |
|  +----------------------+             +------------------------+ |
|  | Public Subnet (AZ-a) |             | Private Subnet (AZ-a)  | |
|  | 10.10.10.0/24        |             | 10.10.20.0/24          | |
|  |                      |             |                        | |
|  |  Jenkins EC2         |   MySQL     |   RDS MySQL            | |
|  |  (Ubuntu 22)         +-----------> |   (private)            | |
|  |  SG: 22/8080 from    |   3306      |   SG: 3306 only from   | |
|  |     MY_IP/32         |             |       Jenkins SG       | |
|  +----------+-----------+             +-----------+------------+ |
|             |                                       |            |
|             |                                       |            |
|  +----------v-----------+             +------------v-----------+ |
|  | Public Subnet (AZ-b) |             | Private Subnet (AZ-b)  | |
|  | 10.10.11.0/24        |             | 10.10.21.0/24          | |
|  +----------------------+             +------------------------+ |
|                                                                  |
|  Internet Gateway (IGW)                                          |
|  - Public RT: 0.0.0.0/0 -> IGW                                   |
|  - Private RT: no default route to IGW (no NAT in Project 1)     |
+------------------------------------------------------------------+



Architecture diagram (even ASCII)
What resources exist
How to deploy
How to destroy
Cost notes