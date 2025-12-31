variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "env" { type = string }

# Networking
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

# Access control
variable "allowed_ssh_cidr" {
  type        = string
  description = "Your public IP /32 allowed to SSH and access Jenkins UI"
}

# EC2 / SSH key
variable "key_name" { type = string }
variable "public_key_path" { type = string }
variable "jenkins_instance_type" { type = string }

# RDS
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
