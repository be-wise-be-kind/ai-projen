# Purpose: Output values from RDS module
# Scope: Exports database connection details and security configuration
# Overview: Provides output values from the RDS module including database endpoint, port,
#     database name, and security group ID for application configuration and integration.

output "endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "address" {
  description = "RDS instance address"
  value       = aws_db_instance.main.address
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "database_name" {
  description = "Name of the default database"
  value       = aws_db_instance.main.db_name
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.id
}
