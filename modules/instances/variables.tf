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

variable "ssh_secure_ip" {
  type        = list(string)
  description = "Pass IP address that are allowed to connect to the ec2 instance using ssh protocol"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}