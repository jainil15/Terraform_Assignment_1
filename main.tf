terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

data "tls_public_key" "mykeypair_public" {
  private_key_openssh = file("./mykeypair.pem")
}

locals {
  server_name  = "Jainils_Server"
  my_public_ip = jsondecode(data.http.my_public_ip.response_body).ip
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = data.tls_public_key.mykeypair_public.public_key_openssh
}

resource "aws_security_group" "allow_http_and_ssh" {
  name        = "allow_http_and_ssh"
  description = "This security groups allows http and ssh inbound traffic from all sources"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
  }
  ingress {
    cidr_blocks = ["${local.my_public_ip}/32"]
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

resource "aws_instance" "app_server" {
  ami                    = "ami-06b72b3b2a773be2b"
  key_name               = aws_key_pair.mykeypair.key_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_and_ssh.id]
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

output "instance_ip_address" {
  value = aws_instance.app_server.public_ip
}

output "my_ip" {
  value = local.my_public_ip
}
