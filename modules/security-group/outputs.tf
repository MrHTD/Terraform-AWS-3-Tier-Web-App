output "frontend_sg_id" {
  description = "ID of the frontend security group"
  value = aws_security_group.frontend_sg.id
}

output "backend_sg_id" {
  description = "ID of the backend security group"
  value = aws_security_group.backend_sg.id  
}

output "nat_instance_sg_id" {
  description = "ID of the NAT instance security group"
  value = aws_security_group.nat_instance_sg.id
  
}

output "db_sg_id" {
  description = "ID of the database security group"
  value = aws_security_group.db_sg.id  
}