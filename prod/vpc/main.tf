locals {
  vpc_name = "${var.environment}-vpc"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = "10.0.0.0/16"

  azs = ["ap-southeast-2a", "ap-southeast-2b"]
  database_subnets = ["10.0.99.0/24", "10.0.100.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  # for private subnets
  # enable_nat_gateway     = true
  # single_nat_gateway     = true
  # one_nat_gateway_per_az = false

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
