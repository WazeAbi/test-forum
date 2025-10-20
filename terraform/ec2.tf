# Génération de clé SSH
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Sauvegarde de la clé privée
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "./deployer-key.pem"
  file_permission = "0600"
}

# Paire de clés AWS
resource "aws_key_pair" "deployer" {
  key_name   = "Alex-AWS-KEY-TERRAFORM"
  public_key = tls_private_key.key.public_key_openssh
}

# Groupe de sécurité pour le serveur web
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
  ami           = "ami-0a0e5d9c7acc336f1"  # Ubuntu 22.04 LTS pour eu-west-3
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu

              # Installation de Docker Compose v2
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Création du répertoire de travail
              mkdir -p /home/ubuntu/app
              chown ubuntu:ubuntu /home/ubuntu/app
              EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}
