locals {
  application_db_name       = "${var.environment}_application"
  application_db_identifier = "${var.environment}-application"
}

data "aws_ssm_parameter" "master_password" {
  name = "/${var.environment}/application-postgres-master-password"
}

data "aws_ssm_parameter" "master_username" {
  name = "/${var.environment}/application-postgres-master-username"
}

resource "aws_db_subnet_group" "application_db" {
  name       = "${local.application_db_name}-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "${local.application_db_name}-subnet-group"
  }
}

resource "aws_db_instance" "application_db" {
  allocated_storage         = 20
  storage_type              = "standard"
  engine                    = "postgres"
  engine_version            = "13"
  instance_class            = "db.t4g.micro"
  identifier                = local.application_db_identifier
  name                      = local.application_db_name
  final_snapshot_identifier = "${local.application_db_identifier}-final-snapshot"
  username                  = "master"
  password                  = "thiswillchange!"
  port                      = 5432
  multi_az                  = false
  db_subnet_group_name      = aws_db_subnet_group.application_db.name
  vpc_security_group_ids    = var.vpc_sg_ids
  publicly_accessible       = false
  skip_final_snapshot       = false
  backup_retention_period   = 5                     # backup daily, but oldest backup will be 5 days ago. auto delete anything older than that
  backup_window             = "15:30-16:30"         # UTC, so Sydney time is: 1:30 AM - 2: 30 AM (for +10 offset)
  maintenance_window        = "Sat:14:00-Sat:15:00" # This is UTC, so Sydney time is Sun 00:00 AM - Sun 1:00 AM (for +10 offset)
  # parameter_group_name = "default.mysql5.7"
  deletion_protection = true
  tags = {
    Environment = var.environment
    Name        = local.application_db_name
  }
}

# module "db" {
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   version = "~> 2.0"

#   name = local.db_name

#   engine         = "aurora-postgresql"
#   engine_version = "10.7"
#   engine_mode    = "serverless"

#   vpc_id  = var.vpc_id
#   subnets = var.subnets

#   replica_scale_enabled   = false
#   replica_count           = 0
#   allowed_security_groups = var.allowed_sg_ids
#   allowed_cidr_blocks     = ["10.0.101.0/24", "10.0.102.0/24"]
#   instance_type           = "db.r4.large"
#   storage_encrypted       = false
#   apply_immediately       = true
#   monitoring_interval     = 60

#   # db_parameter_group_name         = "default"
#   # db_cluster_parameter_group_name = "default"

#   # enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

#   username = data.aws_ssm_parameter.master_username.value
#   password = data.aws_ssm_parameter.master_password.value

#   tags = {
#     Environment = var.environment
#     Name        = local.db_name
#   }
# }
