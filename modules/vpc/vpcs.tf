# Creating VPC
resource "aws_vpc" "app_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "${var.env}-vpc"
  }
}


