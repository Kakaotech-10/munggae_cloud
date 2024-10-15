provider "aws" {
  default_tags {
    tags = local.tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }
  backend "s3" {
    bucket         = "munggae-tfstate-bucket" # 버킷 이름
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "munggae-tfstate-lock" # DB 이름
    encrypt        = true
  }

  required_version = ">= 1.4.2"
}


# Kubernetes Provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm Provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}