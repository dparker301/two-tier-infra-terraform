terraform {
  backend "s3" {
    bucket         = "globaltnr-tf-state-1767138501"
    key            = "two-tier/project1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "globaltnr-terraform-locks"
    encrypt        = true
  }
}
