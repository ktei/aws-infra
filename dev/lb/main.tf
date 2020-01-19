resource "aws_lb" "public_lb" {
  name                             = "public-lb-${var.environment}"
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = var.public_subnets
  security_groups                  = var.security_groups
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "public_lb-${var.environment}"
  }
}
