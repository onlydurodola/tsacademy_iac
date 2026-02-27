output "project_context" {
  description = "project context returned from core module"
  value       = module.core.project_context
}

output "vpc_id" {
  description = "VPC ID created by VPC module"
  value       = module.vpc.vpc_id
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend EC2 instance"
  value       = module.ec2.frontend_public_ip
}

output "backend_private_ip" {
  description = "Private IP address of the backend EC2 instance"
  value       = module.ec2.backend_private_ip
}

output "backend_public_ip" {
  description = "Public IP address of the backend EC2 instance"
  value       = module.ec2.backend_public_ip
}
