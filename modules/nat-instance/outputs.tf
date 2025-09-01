output "nat_network_interface_id" {
  value = aws_instance.nat.primary_network_interface_id
}

output "nat_instance_id" {
  value = aws_instance.nat.id
}