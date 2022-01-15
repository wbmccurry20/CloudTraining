provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "backend-bucket" {
  bucket = "backend-bucket"
}