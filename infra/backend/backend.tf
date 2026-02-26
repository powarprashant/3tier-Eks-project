terraform {
  backend "s3" {
    bucket       = "tfstate-three-tier-app"
    key          = "global/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}