output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "applications_cluster_name" {
  value = module.ecs.applications_cluster_name
}

output "ecs_sg_id" {
  value = module.sg.ecs_sg_id
}

# TODO: remove http listener soon
output "public_lb_listener_arn" {
  value = module.lb.public_lb_listener_arn
}

output "public_lb_listener_https_arn" {
  value = module.lb.public_lb_listener_https_arn
}

output "application_db_endpoint" {
  value = module.db.application_db_endpoint
}

# output "application_cache_endpoint" {
#   value = module.cache.application_cache_endpoint
# }

output "application_efs_id" {
  value = module.efs.application_efs_id
}
