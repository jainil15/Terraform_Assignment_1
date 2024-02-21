
variable "env" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC's cidr block"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "List of Availability zones"
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
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(any)
  description = "Private subnet tags"
  default     = {}
}
