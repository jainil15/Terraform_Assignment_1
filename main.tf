terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# For assigning region
provider "aws" {
  region = "ap-south-1"
}

# Accessing ifconfig.com for accessing my ip address
data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

# Creating public key from the private key which was created before
data "tls_public_key" "mykeypair_public" {
  private_key_openssh = file("./mykeypair.pem")
}

# Local Variables
locals {
  server_name = "Jainils_Server"
  vpc_name    = "Jainils_VPC"
  # Getting my_ip from the json data
  my_public_ip = jsondecode(data.http.my_public_ip.response_body).ip
}

# Creating VPC
resource "aws_vpc" "app_vpc" {
  cidr_block       = "138.82.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "${local.vpc_name}"
  }
}

# Creating subnet
resource "aws_subnet" "public_subnet_ap_south_1a" {
  vpc_id            = aws_vpc.app_vpc.id
  availability_zone = "ap-south-1a"
  cidr_block        = "138.82.0.64/26"
  depends_on        = [aws_vpc.app_vpc]
  tags = {
    Name = "Public_Subnet_1"
  }
}

# Creating internet gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "Jainils_IGW"
  }
}

# Creating route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Name = "Public_Route_Table_1"
  }
}

# Associating subnet with route table
resource "aws_route_table_association" "subnet_association_public_subnet_ap_south_1a" {
  subnet_id      = aws_subnet.public_subnet_ap_south_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Creating key pair for ssh access
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = data.tls_public_key.mykeypair_public.public_key_openssh # Getting public key from private key
}

# Creating security group for http and ssh access and all outbound access
resource "aws_security_group" "allow_http_and_ssh" {
  name        = "allow_http_and_ssh"
  description = "This security groups allows http and ssh inbound traffic from all sources"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
  }
  ingress {
    cidr_blocks = ["${local.my_public_ip}/32"] # Only MY IP Access
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
  }
}

# Creating aws ec2 instance with web server
resource "aws_instance" "app_server" {
  ami                         = "ami-06b72b3b2a773be2b"
  key_name                    = aws_key_pair.mykeypair.key_name
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_ap_south_1a.id
  vpc_security_group_ids      = [aws_security_group.allow_http_and_ssh.id]
  associate_public_ip_address = true
  tags = {
    Name = "${local.server_name}"
  }
  user_data = <<EOF
#!bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>HELLO WORLD FROM $(hostname -f)</h1>" > /var/www/html/index.html
systemctl restart httpd
  EOF
}

# OUTPUTS:
output "instance_ip_address" {
  value = aws_instance.app_server.public_ip
}

output "my_ip" {
  value = local.my_public_ip
}
