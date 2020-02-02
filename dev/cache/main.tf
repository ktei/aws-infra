locals {
  application_cache_name       = "${var.environment}_application"
}

resource "aws_elasticache_subnet_group" "application_cache" {
  name       = "${local.application_cache_name}-subnet-group"
  subnet_ids = var.subnets
}

resource "aws_elasticache_cluster" "application_cache" {
  cluster_id           = "cluster-application-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.application_cache.name
  security_group_ids   = var.vpc_sg_ids
}
