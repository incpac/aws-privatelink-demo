output "consumer_endpoint_dns_names" {
  description = "Dmoain names of the Consumer VPC Endpoint"
  value       = [for dns_entry in aws_vpc_endpoint.consumer_privatelink.dns_entry : "https://${dns_entry.dns_name}"]
}

output "consumer_public_ip" {
  description = "Public IP address of the Consumer instance"
  value       = aws_instance.consumer.public_ip
}
