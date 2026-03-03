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
    aws = aws.primary
  }

  db_password = var.db_password
}