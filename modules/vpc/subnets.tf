# Creating private subnet
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    { Name = "${var.env}-private-${var.azs[count.index]}" },
    var.private_subnet_tags
  )
}

# Creating public subnet
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    { Name = "${var.env}-public-${var.azs[count.index]}" },
    var.public_subnet_tags
  )
}
