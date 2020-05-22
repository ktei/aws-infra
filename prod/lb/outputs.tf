output "public_lb_listener_arn" {
  value = aws_lb_listener.public_lb_listener.arn
}

output "public_lb_listener_https_arn" {
  value = aws_lb_listener.public_lb_listener_https.arn
}
