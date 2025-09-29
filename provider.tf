provider "aws" {
    region = "us-east-1"
}
terraform {
    backend "s3" {
        bucket  = "terraform-bucket-85"
        key     = "ecommerce_terraform/dev/terraform.tfstate"
        region  = "us-east-1"
    }
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}