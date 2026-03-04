resource "aws_secretsmanager_secret" "db_password" {
  name = "three-tier-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_db_subnet_group" "aurora" {
  name       = "three-tier-db-subnet"
  subnet_ids = var.private_subnets

  tags = {
    Name = "aurora-subnet-group"
  }
}

resource "aws_security_group" "aurora" {
  name        = "aurora-sg"
  description = "Allow DB access from EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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

  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  skip_final_snapshot = true
}