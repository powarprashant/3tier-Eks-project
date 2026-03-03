############################################
#  Secrets Manager – DB Password
############################################

resource "aws_secretsmanager_secret" "db_password" {
  name = "three-tier-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

############################################
#  Global Aurora Cluster
############################################

resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "three-tier-global-db"
  engine                    = "aurora-mysql"
}

############################################
#  Primary Aurora Cluster (ap-south-1)
############################################

resource "aws_rds_cluster" "primary" {
  provider = aws.primary

  cluster_identifier          = "three-tier-primary-db"
  engine                      = "aurora-mysql"
  engine_mode                 = "global"   # required for global clusters
  master_username             = "dbadmin"
  master_password             = var.db_password
  global_cluster_identifier   = aws_rds_global_cluster.global.id

  storage_encrypted           = true
  skip_final_snapshot         = true
}

############################################
#  Secondary Aurora Cluster (us-east-1)
############################################

resource "aws_rds_cluster" "secondary" {
  provider = aws.secondary

  cluster_identifier          = "three-tier-secondary-db"
  engine                      = "aurora-mysql"
  engine_mode                 = "global"
  global_cluster_identifier   = aws_rds_global_cluster.global.id

  # IMPORTANT:
  # Secondary cluster MUST NOT define master_username or master_password
  # AWS will replicate automatically from primary

  storage_encrypted           = true
  skip_final_snapshot         = true
}