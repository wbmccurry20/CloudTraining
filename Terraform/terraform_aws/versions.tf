terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "1.1.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "1.1.1"
    }
  }

  required_version = ">= 0.14.0"
}
