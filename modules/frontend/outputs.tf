output "frontend_public_ip" {
    description = "Public IP of the frontend instance"
    value = aws_instance.frontend.public_ip
}

output "frontend_sg_id" {
  value = aws_security_group.frontend_sg.id
}