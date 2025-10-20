variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "test-forum"
}
variable "db_password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
}
variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}
