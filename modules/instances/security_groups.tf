# Creating security group for public instances
resource "aws_security_group" "public" {
  name        = "${var.env}-public-sg"
  description = "public security group"
  vpc_id      = var.vpc_id
}

# Creating secrurity group for private instances.
resource "aws_security_group" "private" {
  name        = "${var.env}-private-sg"
  description = "private security group"
  vpc_id      = var.vpc_id
}
