variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "test-forum"
}

variable "app_port" {
  description = "Port exposed by the docker image"
  type        = number
  default     = 3000
}

variable "db_password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
}
