output "backend_private_ip" {
    description = "Private IP of the backend instance"
    value = aws_instance.backend.private_ip
}