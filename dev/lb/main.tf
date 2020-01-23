locals {
  port           = 80
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
    Environment = var.environment
    Name        = local.public_lb_name
  }
}

resource "aws_lb_target_group" "public_lb_tg" {
  depends_on  = [aws_lb.public_lb]
  name        = "${local.public_lb_name}-tg"
  target_type = "ip"
  protocol    = "HTTP"
  port        = local.port
  vpc_id      = var.vpc_id
  health_check {
    path = "/"
    port = local.port
  }
  tags = {
    Environment = var.environment
    Name        = "${local.public_lb_name}-tg"
  }
}

resource "aws_lb_listener" "public_lb_listener" {
  depends_on        = [aws_lb_target_group.public_lb_tg]
  load_balancer_arn = aws_lb.public_lb.arn
  port              = "${local.port}"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.public_lb_tg.arn
    type             = "forward"
  }
}
