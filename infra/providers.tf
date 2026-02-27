terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"   # FIX: Pin provider to v5, avoid v6 breaking changes
    }
  }
}

variable "primary_region" {
  default = "us-east-1"
}

variable "secondary_region" {
  default = "ap-south-1"
}

# Primary provider (used for primary EKS & Aurora writer)
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

# Secondary provider (used for secondary EKS & Aurora reader)
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# Default provider (optional, used when a provider alias is not explicitly passed)
provider "aws" {
  region = var.primary_region
}