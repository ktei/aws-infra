output "public_lb_http_sg_id" {
  value = aws_security_group.public_lb_http.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "application_db_sg_id" {
  value = aws_security_group.application_db_sg.id
}
