locals {
  public_lb_http_name    = "${var.environment}-public-lb-http"
  ecs_sg_name            = "${var.environment}-ecs-sg"
  application_db_sg_name = "${var.environment}-application-db-sg"
  application_cache_sg_name = "${var.environment}-application-cache-sg"
}

# Control access to public LB via HTTP/HTTPS
resource "aws_security_group" "public_lb_http" {
  name        = local.public_lb_http_name
  description = "Control access to public LB via HTTP/HTTPS"
  vpc_id      = var.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.public_lb_http_name
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = local.ecs_sg_name
  description = "Allow inbound access from the LB only"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 5000
    to_port         = 5000
    security_groups = [aws_security_group.public_lb_http.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.public_lb_http.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.public_lb_http.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.ecs_sg_name
  }
}

resource "aws_security_group" "application_db_sg" {
  depends_on  = [aws_security_group.ecs_sg]
  name        = local.application_db_sg_name
  description = "Allow inbound access from the ECS"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.ecs_sg.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is JUST for testing TODO: remove this"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["101.164.133.234/32"]
    description = "IP for Ping"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["124.168.74.154/32"]
    description = "IP for Robert"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["119.18.0.179/32"]
    description = "IP for Rui"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["120.152.112.144/32"]
    description = "IP for Steve"
  }

  egress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.application_db_sg_name
  }
}

resource "aws_security_group" "application_cache_sg" {
  depends_on  = [aws_security_group.ecs_sg]
  name        = local.application_cache_sg_name
  description = "Allow inbound access from the ECS"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    security_groups = [aws_security_group.ecs_sg.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is JUST for testing TODO: remove this"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["101.164.133.234/32"]
    description = "IP for Ping"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["124.168.74.154/32"]
    description = "IP for Robert"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["119.18.0.179/32"]
    description = "IP for Rui"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["120.152.112.144/32"]
    description = "IP for Steve"
  }

  egress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.application_cache_sg_name
  }
}
