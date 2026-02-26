provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "tfstate-three-tier-app"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "locktable" {
  name         = "tfstate-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}