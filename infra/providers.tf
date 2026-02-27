terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0, < 6.0.0"
    }
  }
}

variable "primary_region" {
  default = "us-east-1"
}

variable "secondary_region" {
  default = "ap-south-1"
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

provider "aws" {
  region = var.primary_region
}