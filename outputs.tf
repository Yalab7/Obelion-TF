output "frontend_public_ip" {
  value = aws_instance.frontend_ec2.public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend_ec2.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}