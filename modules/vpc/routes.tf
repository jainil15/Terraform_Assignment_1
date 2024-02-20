# Creating Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Name = "${var.env}-public-route-table"
  }
}

# Creating Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env}-private-route-table"
  }
}


# Associating subnet with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

# Associating subnet with private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
