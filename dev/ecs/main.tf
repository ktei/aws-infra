locals {
  applications_cluster_name = "${var.environment}-applications"
}


resource "aws_ecs_cluster" "applications_cluster" {
  name = local.applications_cluster_name
}
