output "frontend_public_ip" {
    description = "Public IP of the frontend instance"
    value = aws_instance.frontend.public_ip
}