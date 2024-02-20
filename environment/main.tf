terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "jainil-terraform-assignment-2-backend"
    region         = "ap-south-1"
    encrypt        = true
    profile        = "terra-user"
    role_arn       = "arn:aws:iam::171358186705:role/terraform"
    dynamodb_table = "jainil-terraform-lock-table"
    key            = "assignment-1/test/terraform.tfstate"
  }
}

locals {
  env = "test"
}

# For assigning region
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source                     = "../modules/vpc"
  env                        = local.env
  azs                        = ["ap-south-1a"]
  vpc_cidr_block             = "77.23.0.0/16"
  private_subnet_cidr_blocks = ["77.23.0.64/26"]
  public_subnet_cidr_blocks  = ["77.23.2.64/26"]
  private_subnet_tags        = {}
  public_subnet_tags         = {}
}

module "instances" {
  source        = "../modules/instances"
  env           = local.env
  ami_id        = "ami-06b72b3b2a773be2b"
  instance_type = "t2.micro"

  ssh_secure_ip      = ["110.20.12.122/32"]
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
}

