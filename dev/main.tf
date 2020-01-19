terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source      = "./vpc"
  namespace   = "pingai"
  environment = "dev"
}

module "lb_sg" {
  source      = "./sg"
  namespace   = "pingai"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
}
