# Creating security group for http and ssh access and all outbound access
resource "aws_security_group" "public" {
  name        = "${var.env}-public-sg"
  description = "public security group"
  vpc_id      = var.vpc_id
}

# Creating private secrurity group with no inbound outbound access for now.
resource "aws_security_group" "private" {
  name        = "${var.env}-private-sg"
  description = "private security group"
  vpc_id      = var.vpc_id
}
