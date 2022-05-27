provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "b" {
  bucket = "gh_actions_bucket"

  tags = {
    Name        = "gh_bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}