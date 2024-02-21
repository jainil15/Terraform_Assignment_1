variable "env" {
  type        = string
  description = "Environment Name"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type of instance"
  default     = "t2.micro"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet ids"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids"
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
  default     = []
  description = "Full ingress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional)"
}

variable "public_sg_egress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  description = "Full engress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional)"
  default = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }]
}

variable "private_sg_ingress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  default     = []
  description = "Full ingress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional)"
}

variable "private_sg_egress_with_cidr_blocks" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
  default     = []
  description = "Full ingress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional)"

}

