terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "Alex-AWS-KEY-TERRAFORM"
  public_key = tls_private_key.key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}

# Security Group pour EC2
resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web"
  description = "Security group for web server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# Instance EC2
resource "aws_instance" "web" {
  ami = "ami-0a0e5d9c7acc336f1"  # Ubuntu 22.04 LTS pour eu-west-3
  key_name        = aws_key_pair.deployer.key_name
  instance_type   = "t3.micro"

  security_groups = [aws_security_group.web.name]

  user_data = <<-EOF
#!/bin/bash
set -e

# Logs pour debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Début de l'installation Docker"

# Mise à jour du système
apt-get update -y

# Installation de Docker
apt-get install -y docker.io

# Démarrage et activation de Docker
systemctl start docker
systemctl enable docker

# Ajout de l'utilisateur ubuntu au groupe docker
usermod -a -G docker ubuntu

# Vérification de l'installation
docker --version

echo "Installation Docker terminée"
EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}
