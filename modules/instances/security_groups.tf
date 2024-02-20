
# Creating security group for http and ssh access and all outbound access
resource "aws_security_group" "public" {
  name        = "${var.env}-public-sg"
  description = "This security groups allows http inbound traffic from all sources and ssh from my ip"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
  }
  ingress {
    cidr_blocks = var.ssh_secure_ip # Only MY IP Access
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

# Creating private secrurity group with no inbound outbound access for now.
resource "aws_security_group" "private" {
  name        = "${var.env}-private-sg"
  description = "No access for now"
  vpc_id      = var.vpc_id
}

