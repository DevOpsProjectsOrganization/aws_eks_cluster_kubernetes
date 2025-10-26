provider "aws" {
  region = "us-east-1"
}
terraform {
    backend "s3" {
        bucket  = "terraform-bucket-85"
        key     = "ecommerce_terraform/dev-helm-chart/terraform.tfstate"
        region  = "us-east-1"
    }
    required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}

provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
    }
}
