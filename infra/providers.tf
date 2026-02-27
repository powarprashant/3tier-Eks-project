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

# Default provider (required for modules that don't specify alias)
provider "aws" {
  region = var.primary_region
}