terraform {
  backend "s3" {
    bucket         = "tfstate-three-tier-app"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}