output "public_ip_address" {
  description = "AWS Lightsail instance public IP address."
  value       = aws_lightsail_instance.this.public_ip_address
}
