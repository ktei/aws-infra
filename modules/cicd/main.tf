terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-southeast-2"
}

locals {
  prefix = "${var.environment}-${var.appname}"
}

data "aws_caller_identity" "current" {}

# create artifacts bucket
resource "aws_s3_bucket" "build_artifacts" {
  bucket        = "${local.prefix}-build-artifacts-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = false

  tags = {
    Name        = "${local.prefix}-build-artifacts"
    Environment = "${var.environment}"
  }
}

data "aws_iam_policy_document" "build_artifacts_policy" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      join("", aws_s3_bucket.build_artifacts.*.arn),
      "${join("", aws_s3_bucket.build_artifacts.*.arn)}/*"
    ]

    effect = "Allow"
  }
}

# create artifacts bucket access policy
resource "aws_iam_policy" "build_artifacts_policy" {
  depends_on = [aws_s3_bucket.build_artifacts]
  name       = "${local.prefix}-build-artifacts-policy"
  policy     = data.aws_iam_policy_document.build_artifacts_policy.json
}

# create ecr repo
resource "aws_ecr_repository" "images_repo" {
  name = "${local.prefix}-images"
}

# create codebuild
module "codebuild" {
  source             = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.17.0"
  namespace          = var.appname
  name               = "codebuild"
  stage              = var.environment
  build_image        = "aws/codebuild/standard:2.0"
  build_compute_type = "BUILD_GENERAL1_LARGE"
  image_repo_name    = aws_ecr_repository.images_repo.name
  privileged_mode    = true
}

# attach artifacts bucket access policy to codebuild
resource "aws_iam_role_policy_attachment" "codebuild_build_artifacts_access" {
  role       = module.codebuild.role_id
  policy_arn = aws_iam_policy.build_artifacts_policy.arn
}

# data "aws_iam_policy_document" "codepipeline_assume_role" {
#   statement {
#     sid = ""

#     actions = [
#       "sts:AssumeRole"
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }

#     effect = "Allow"
#   }
# }

# resource "aws_iam_role" "codepipeline" {
#   name               = "${local.prefix}-codepipeline"
#   assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "codepipeline" {
#   role       = aws_iam_role.codepipeline.id
#   policy_arn = aws_iam_policy.codepipeline.arn
# }

# data "aws_iam_policy_document" "codepipeline" {
#   statement {
#     sid = ""

#     actions = [
#       "elasticbeanstalk:*",
#       "ec2:*",
#       "elasticloadbalancing:*",
#       "autoscaling:*",
#       "cloudwatch:*",
#       "s3:*",
#       "sns:*",
#       "cloudformation:*",
#       "rds:*",
#       "sqs:*",
#       "ecs:*",
#       "iam:PassRole",
#       "logs:PutRetentionPolicy",
#     ]

#     resources = ["*"]
#     effect    = "Allow"
#   }
# }

# resource "aws_iam_policy" "codepipeline" {
#   name   = "${local.prefix}-codepipeline-policy"
#   policy = data.aws_iam_policy_document.codepipeline.json
# }

# resource "aws_iam_role_policy_attachment" "build_artifacts_access" {
#   role       = aws_iam_role.codepipeline.id
#   policy_arn = aws_iam_policy.build_artifacts_policy.arn
# }

# data "aws_iam_policy_document" "codebuild_access_policy" {
#   statement {
#     sid = ""

#     actions = [
#       "codebuild:*"
#     ]

#     resources = [module.codebuild.project_id]
#     effect    = "Allow"
#   }
# }

# resource "aws_iam_policy" "codebuild_access_policy" {
#   name   = "${local.prefix}-codebuild-access-policy"
#   policy = data.aws_iam_policy_document.codebuild_access_policy.json
# }

# resource "aws_iam_role_policy_attachment" "codebuild_access" {
#   role       = aws_iam_role.codepipeline.id
#   policy_arn = aws_iam_policy.codebuild_access_policy.arn
# }