terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
  backend "s3" {
    bucket = module.aws_backend.bucket
    region = var.region
    key = var.AWS_ACCESS_KEY
  }
  required_version = ">= 0.14.0"
  backend "s3" {
    bucket = module.aws_backend.bucket
    region = var.region
  }
}
