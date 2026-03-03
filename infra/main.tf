module "primary" {
  source = "./regions/primary"

  providers = {
    aws = aws.primary
  }
}

module "secondary" {
  source = "./regions/secondary"

  providers = {
    aws = aws.secondary
  }
}

module "aurora" {
  source = "./modules/aurora"

  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }

  db_password = var.db_password
}