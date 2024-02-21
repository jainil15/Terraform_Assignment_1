resource "aws_security_group_rule" "public_ingress" {
  count             = length(var.public_sg_ingress_with_cidr_blocks)
  type              = "ingress"
  from_port         = var.public_sg_ingress_with_cidr_blocks[count.index].from_port
  to_port           = var.public_sg_ingress_with_cidr_blocks[count.index].to_port
  protocol          = var.public_sg_ingress_with_cidr_blocks[count.index].protocol
  cidr_blocks       = var.public_sg_ingress_with_cidr_blocks[count.index].cidr_blocks
  ipv6_cidr_blocks  = var.public_sg_ingress_with_cidr_blocks[count.index].ipv6_cidr_blocks
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_egress" {
  count             = length(var.public_sg_egress_with_cidr_blocks)
  type              = "egress"
  from_port         = var.public_sg_egress_with_cidr_blocks[count.index].from_port
  to_port           = var.public_sg_egress_with_cidr_blocks[count.index].to_port
  protocol          = var.public_sg_egress_with_cidr_blocks[count.index].protocol
  cidr_blocks       = var.public_sg_egress_with_cidr_blocks[count.index].cidr_blocks
  ipv6_cidr_blocks  = var.public_sg_egress_with_cidr_blocks[count.index].ipv6_cidr_blocks
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "private_ingress" {
  count             = length(var.private_sg_ingress_with_cidr_blocks)
  type              = "ingress"
  from_port         = var.private_sg_ingress_with_cidr_blocks[count.index].from_port
  to_port           = var.private_sg_ingress_with_cidr_blocks[count.index].to_port
  protocol          = var.private_sg_ingress_with_cidr_blocks[count.index].protocol
  cidr_blocks       = var.private_sg_ingress_with_cidr_blocks[count.index].cidr_blocks
  ipv6_cidr_blocks  = var.private_sg_ingress_with_cidr_blocks[count.index].ipv6_cidr_blocks
  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_egress" {
  count             = length(var.private_sg_egress_with_cidr_blocks)
  type              = "egress"
  from_port         = var.private_sg_egress_with_cidr_blocks[count.index].from_port
  to_port           = var.private_sg_egress_with_cidr_blocks[count.index].to_port
  protocol          = var.private_sg_egress_with_cidr_blocks[count.index].protocol
  cidr_blocks       = var.private_sg_egress_with_cidr_blocks[count.index].cidr_blocks
  ipv6_cidr_blocks  = var.private_sg_egress_with_cidr_blocks[count.index].ipv6_cidr_blocks
  security_group_id = aws_security_group.private.id
}
