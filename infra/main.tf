##########################################
# PRIMARY REGION MODULE (ap-south-1)
##########################################
module "primary" {
  source = "./regions/primary"

  providers = {
    aws = aws.primary
  }
}

##########################################
# SECONDARY REGION MODULE (us-east-1)
##########################################
module "secondary" {
  source = "./regions/secondary"

  providers = {
    aws = aws.secondary
  }
}

##########################################
# AURORA GLOBAL DATABASE MODULE
##########################################
module "aurora" {
  source = "./modules/aurora"

  # IMPORTANT — pass both providers
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }

  db_password = var.db_password
}