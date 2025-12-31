aws_region   = "us-east-1"
project_name = "two-tier-flask"
env          = "dev"

vpc_cidr             = "10.10.0.0/16"
public_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
private_subnet_cidrs = ["10.10.20.0/24", "10.10.21.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]

allowed_ssh_cidr = "108.51.206.247/32"

key_name             = "two-tier-dev-key"
public_key_path      = "keys/two-tier-dev-key.pub"
jenkins_instance_type = "t3.medium"

db_name     = "devops"
db_username = "appuser"
db_password = "ChangeMe123!ChangeMe123!"
