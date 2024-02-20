
variable "env" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC's cidr block"
}

variable "azs" {
  type        = list(string)
  description = "List of Availibility zones"
}

variable "private_subnet_cidr_blocks" {
  default     = []
  type        = list(string)
  description = "List of private subnets cidr block"
}


variable "public_subnet_cidr_blocks" {
  default     = []
  type        = list(string)
  description = "List of public subnets cidr block"
}

variable "public_subnet_tags" {
  type        = map(any)
  description = "Public subnet tags"
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "Private subnet tags"
}
