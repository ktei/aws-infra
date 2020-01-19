module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.namespace}-${var.environment}"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
