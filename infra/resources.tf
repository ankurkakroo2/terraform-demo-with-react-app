terraform {
  backend "s3" {
    bucket = "xts-tf-state"
    region = "us-east-1"
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

variable "env_prefix" {
  default = "dev"
}

module "ecr" {
  source = "./module/ecr"
}

module "lb" {
  source          = "./module/loadBalancer"
  subnets         = list(module.network.subnet_1.id, module.network.subnet_2.id)
  security_groups = list(module.security.group_id)
  vpc_id          = module.network.vpc_id
}

module "network" {
  source = "./module/networking"
}

module "security" {
  source = "./module/security"
}

module "ecs" {
  source          = "./module/ecs"
  ecr_url         = module.ecr.ecr_url
  lb_listner      = module.lb.listener
  subnets         = list(module.network.subnet_1.id, module.network.subnet_2.id)
  security_groups = list(module.security.group_id)
  lb_target_group = module.lb.target_group
}

