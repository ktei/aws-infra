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

module "sg" {
  source      = "./sg"
  namespace   = "pingai"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
}

module "lb" {
  source = "./lb"
  namespace   = "pingai"
  environment = "dev"
  public_subnets = module.vpc.public_subnets
  security_groups = [module.sg.public_lb_sg_id]
}

module "ecs" {
  source      = "./ecs"
  namespace   = "pingai"
  environment = "dev"
}
