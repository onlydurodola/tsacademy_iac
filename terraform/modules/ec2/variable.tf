variable "project_name" {
  description = "Project name used for naming EC2 instances"
  type        = string
}

variable "frontend_subnet_id" {
  description = "Subnet ID for the frontend instance (public subnet)"
  type        = string
}

variable "backend_subnet_id" {
  description = "Subnet ID for the backend instance (private subnet)"
  type        = string
}

variable "frontend_sg_id" {
  description = "Security group ID for the frontend instance"
  type        = string
}

variable "backend_sg_id" {
  description = "Security group ID for the backend instance"
  type        = string
}

variable "instance_type_frontend" {
  description = "EC2 instance type for frontend"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_backend" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair for EC2 access"
  type        = string
}
