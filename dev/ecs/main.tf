resource "aws_ecs_cluster" "applications_cluster" {
  name = "applications-${var.environment}"
}
