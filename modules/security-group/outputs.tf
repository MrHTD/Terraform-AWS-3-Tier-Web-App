output "backend_sg_id" {
  description = "ID of the backend security group"
  value = aws_security_group.backend_sg.id  
}

output "nat_instance_sg_id" {
  description = "ID of the nat instance security group"
  value = aws_security_group.nat_instance_sg.id  
}