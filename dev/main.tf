terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-397977497739"
    key    = "dev/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source      = "./vpc"
  environment = "dev"
}

module "sg" {
  source      = "./sg"
  environment = "dev"
  vpc_id      = module.vpc.vpc_id
}

module "lb" {
  source          = "./lb"
  environment     = "dev"
  public_subnets  = module.vpc.public_subnets
  security_groups = [module.sg.public_lb_http_sg_id]
}

module "ecs" {
  source      = "./ecs"
  environment = "dev"
}
