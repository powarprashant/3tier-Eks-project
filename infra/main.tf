module "primary" {
  source = "./regions/primary"
}

module "secondary" {
  source = "./regions/secondary"
}

module "aurora" {
  source = "./modules/aurora"

  db_password = var.db_password
}