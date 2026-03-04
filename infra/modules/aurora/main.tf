resource "aws_secretsmanager_secret" "db_password" {
  name = "three-tier-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_security_group" "aurora" {
  name        = "aurora-sg"
  description = "Allow DB access from anywhere"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "three-tier-db"

  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.3"

  master_username = "dbadmin"
  master_password = var.db_password

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.aurora.id]

  storage_encrypted = true
}