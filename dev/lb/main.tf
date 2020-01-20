locals {
  public_lb_name = "${var.environment}-public-lb"
}


resource "aws_lb" "public_lb" {
  name                             = local.public_lb_name
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = var.public_subnets
  security_groups                  = var.security_groups
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  tags = {
    Name = local.public_lb_name
  }
}
