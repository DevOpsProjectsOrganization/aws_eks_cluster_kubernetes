provider "aws" {
    region = "us-east-1"
}
terraform {
    backend "s3" {
        bucket  = "terraform-bucket-85"
        key     = "ecommerce_terraform/dev/terraform.tfstate"
        region  = "us-east-1"
    }
    required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}
#provider "helm" {
#kubernetes {
#   config_path = "~/.kube/config"
# }
#}

data "aws_eks_cluster" "eks" {
  name = module.eks["main"].cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks["main"].cluster_name
  depends_on = [module.eks]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}