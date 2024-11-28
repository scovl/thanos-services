terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.14.0"
    }
  }
  backend "s3" {
    bucket         = "thanos-eks-terraform-env"
    key            = "xpto-dir/terraform.state"
    region         = "sa-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
