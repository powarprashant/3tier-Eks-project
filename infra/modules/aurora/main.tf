resource "aws_secretsmanager_secret" "db_password" {
  name = "three-tier-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "three-tier-global-db"
  engine                    = "aurora-mysql"
}

resource "aws_rds_cluster" "primary" {
  provider = aws.primary

  cluster_identifier      = "three-tier-primary-db"
  engine                  = "aurora-mysql"
  master_username         = "dbadmin"
  master_password         = var.db_password
  global_cluster_identifier = aws_rds_global_cluster.global.id
}

resource "aws_rds_cluster" "secondary" {
  provider = aws.secondary

  cluster_identifier      = "three-tier-secondary-db"
  engine                  = "aurora-mysql"
  global_cluster_identifier = aws_rds_global_cluster.global.id
}