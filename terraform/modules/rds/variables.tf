variable "project_name" {
  description = "Project name used for naming and tagging RDS resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS subnet group (must span AZs)"
  type        = list(string)
}

variable "database_sg_id" {
  description = "Security group ID that allows database access (from backend only)"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master database username"
  type        = string
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.6"
}
