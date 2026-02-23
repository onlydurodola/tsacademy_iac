variable "project_name" {
  description = "Project name used for tagging and naming AWS resources"
  type        = string
  default     = "taskapp-tsa-terra"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-1"
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "vpc_cidr" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "public subnet CIDR"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "public subnet CIDR"
  type        = list(string)
  default     = ["10.0.2.0/24","10.0.4.0/24"]
}

variable "ssh_key_name" {
  description = "SSH key pair name for EC2 instances"
  type        = string
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "taskapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "taskapp_user"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
