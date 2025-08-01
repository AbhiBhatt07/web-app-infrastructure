# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}database"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false

  multi_az = false

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  monitoring_interval = 0  # ✅ Disabled to avoid IAM error

  deletion_protection = false
  skip_final_snapshot = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-database"
  })
}
