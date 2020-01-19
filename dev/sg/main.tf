# Control access to public LB via HTTP/HTTPS
resource "aws_security_group" "public_lb_http" {
  name        = "public-lb-http-${var.environment}"
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
    Name = "public-lb-http-${var.environment}"
  }
}
