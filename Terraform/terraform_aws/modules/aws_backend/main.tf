provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = "backend_bucket"
}