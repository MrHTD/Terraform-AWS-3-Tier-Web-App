output "backend_private_ip" {
    description = "Private IP of the backend instance"
    value = aws_instance.backend.private_ip
}

output "backend_sg_id" {
    description = "Security Group ID for the backend instances"
    value       = aws_security_group.backend_sg.id
}