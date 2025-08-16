output "frontend_public_ip" {
    description = "Public IP of the frontend instance"
    value = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
    description = "Private IP of the backend instance"
    value = aws_instance.backend.private_ip
}

output "RDS_endpoint" {
    description = "Endpoint of the RDS instance"
    value = aws_db_instance.myRDS.endpoint
}