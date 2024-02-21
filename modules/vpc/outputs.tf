output "private_subnet_ids" {
  value = aws_subnet.private[*].id
  description = "List of private subnet ids"
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
  description = "List of public subnet ids"
}

output "vpc_id" {
  value = aws_vpc.app_vpc.id
  description = "VPC ID"
}

output "private_route_table_id" {
  value = aws_route_table.private.id
  description = "Private route table ID"
}

output "public_route_table_id" {
  value = aws_route_table.public.id
  description = "Public route table ID"
}

output "igw_id" {
  value = aws_internet_gateway.app_igw.id
  description = "Internet Gateway ID"
}