resource "aws_ecs_cluster" "applications_cluster" {
  name = "${var.namespace}-applications-${var.environment}"
}
