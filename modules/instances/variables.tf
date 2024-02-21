variable "env" {
  type        = string
  description = "Name of the environment"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type of instance"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_sg_ingress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  default = [  ]
  description = "Write the full ingress with cidr blocks, to, from, protocol for ingress rules"
}

variable "private_sg_ingress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  default = [  ]
  description = "Write the full ingress with cidr blocks, to, from, protocol for ingress rules"
}

variable "public_sg_egress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  description = "Write the full ingress with cidr blocks, to, from, protocol for egress rules"
  default = [ {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } ]
}

variable "private_sg_egress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  default = [ ]
  description = "Write the full ingress with cidr blocks, to, from, protocol for egress rules"
  
}

