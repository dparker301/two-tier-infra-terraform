module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "jenkins" {
  source           = "./modules/ec2"
  project_name     = var.project_name
  env              = var.env
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  allowed_ssh_cidr = var.allowed_ssh_cidr
  key_name         = var.key_name
  public_key_path  = var.public_key_path
  instance_type    = var.jenkins_instance_type
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  env                = var.env
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  allowed_sg_id      = module.jenkins.security_group_id
}
