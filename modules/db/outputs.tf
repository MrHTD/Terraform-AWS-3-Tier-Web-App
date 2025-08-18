output "RDS_endpoint" {
    description = "Endpoint of the RDS instance"
    value = aws_db_instance.myRDS.endpoint
}