# Repository pour l'API NestJS
resource "aws_ecr_repository" "api" {
  name                 = "${var.project_name}-api"
  image_tag_mutability = "MUTABLE"
}

# Repository pour Sender (Next.js)
resource "aws_ecr_repository" "sender" {
  name                 = "${var.project_name}-sender"
  image_tag_mutability = "MUTABLE"
}

# Repository pour Thread (Next.js)
resource "aws_ecr_repository" "thread" {
  name                 = "${var.project_name}-thread"
  image_tag_mutability = "MUTABLE"
}
