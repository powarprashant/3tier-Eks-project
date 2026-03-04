resource "aws_secretsmanager_secret" "db_password" {
  name = "three-tier-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "three-tier-db"

  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.3"

  master_username = "dbadmin"
  master_password = var.db_password

  skip_final_snapshot = true
}