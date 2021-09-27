locals {
  application_cache_name = "${var.environment}-application"
}

resource "aws_elasticache_subnet_group" "application_cache" {
  name       = "${local.application_cache_name}-subnet-group"
  subnet_ids = var.subnets
}

resource "aws_elasticache_cluster" "application_cache" {
  cluster_id           = local.application_cache_name
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.application_cache.name
  security_group_ids   = var.vpc_sg_ids
}
