locals {
  public_lb_http_name       = "${var.environment}-public-lb-http"
  ecs_sg_name               = "${var.environment}-ecs-sg"
  application_db_sg_name    = "${var.environment}-application-db-sg"
  application_cache_sg_name = "${var.environment}-application-cache-sg"
  bastion_sg_name           = "${var.environment}-bastion-sg"
}

resource "aws_security_group" "public_lb_http" {
  name        = local.public_lb_http_name
  description = "Allow access to public LB via HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS traffic from outside world "
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "lazy work, allow outgoing traffic to whatever"
  }

  tags = {
    Name = local.public_lb_http_name
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = local.ecs_sg_name
  description = "Allow access to LB"
  vpc_id      = var.vpc_id

  # allow incoming traffic from LB
  # this means containers need to listen on port 5000
  ingress {
    protocol        = "tcp"
    from_port       = 5000
    to_port         = 5000
    security_groups = [aws_security_group.public_lb_http.id]
  }

  # allow peer EC2 access
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    self      = true
  }

  # allow outgoing traffic to whatever
  # TODO: apparently this egress is not secure enough
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "lazy work, allow outgoing traffic to whatever"
  }

  tags = {
    Name = local.ecs_sg_name
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = local.bastion_sg_name
  description = "Allow access outside the VPC to bastion host"
  vpc_id      = var.vpc_id
  # allow incoming SSH traffic from outside
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TODO: not secure enough
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "application_db_sg" {
  depends_on  = [aws_security_group.ecs_sg, aws_security_group.bastion_sg]
  name        = local.application_db_sg_name
  description = "Enable access to ECS and bastion"
  vpc_id      = var.vpc_id

  # -- ECS --
  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.ecs_sg.id]
    description     = "allow incoming traffic from ECS"
  }
  egress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.ecs_sg.id]
    description     = "allow outgoing traffic to ECS"
  }
  # -- /ECS --

  # -- bastion --
  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "allow incoming traffic from bastion"
  }
  egress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "allow outgoing traffic to bastioin"
  }
  # -- /bastioin --

  tags = {
    Name = local.application_db_sg_name
  }
}

resource "aws_security_group" "application_cache_sg" {
  depends_on  = [aws_security_group.ecs_sg]
  name        = local.application_cache_sg_name
  description = "Allow access to ECS"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    security_groups = [aws_security_group.ecs_sg.id]
    description     = "Allow incoming traffic from ECS"
  }
  egress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    security_groups = [aws_security_group.ecs_sg.id]
    description     = "Allow outgoing traffic to ECS"
  }

  tags = {
    Name = local.application_cache_sg_name
  }
}
