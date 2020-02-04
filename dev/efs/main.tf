locals {
  application_efs_creation_token = "${var.environment}-application-efs"
}

resource "aws_efs_file_system" "application_efs" {
  creation_token = local.application_efs_creation_token

  tags = {
    Name = local.application_efs_creation_token
  }
}

resource "aws_efs_mount_target" "application_efs_mount" {
  for_each        = var.subnets
  security_groups = var.security_groups
  file_system_id  = aws_efs_file_system.application_efs.id
  subnet_id       = each.key
}

# resource "aws_efs_mount_target" "application_efs_mount_subnet_2" {
#   count          = length(var.subnets) > 1 ? 1 : 0
#   file_system_id = aws_efs_file_system.application_efs.id
#   subnet_id      = var.subnets[1]
# }
