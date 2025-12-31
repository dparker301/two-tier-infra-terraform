output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
