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

output "public_lb_listener_arn" {
  value = module.lb.public_lb_listener_arn
}
