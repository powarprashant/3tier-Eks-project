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
    aws = aws.primary   # Aurora should use the PRIMARY region
  }

  db_password = var.db_password
}