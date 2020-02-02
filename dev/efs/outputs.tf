output "application_efs_arn" {
  value = aws_efs_file_system.application_efs.arn
}

output "application_efs_id" {
  value = aws_efs_file_system.application_efs.id
}
