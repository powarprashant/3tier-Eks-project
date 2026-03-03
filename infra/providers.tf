###########################################
# PRIMARY REGION PROVIDER
###########################################
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

###########################################
# SECONDARY REGION PROVIDER
###########################################
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}