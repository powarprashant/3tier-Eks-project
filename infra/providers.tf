provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "use1"
  region = var.db_region
}