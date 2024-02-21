output "private_sg_id" {
  value = aws_security_group.private.id
  description = "Private security group id"
}
output "public_sg_id" {
  value = aws_security_group.public.id
  description = "Public security group id"
}

output "public_instance_id" {
  value = aws_instance.public[*].id
  description = "Public ec2 instance id"  
}


output "private_instance_id" {
  value = aws_instance.private[*].id  
  description = "Private ec2 instance id"
}
