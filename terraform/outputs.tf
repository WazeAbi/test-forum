output "ec2_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.web.public_ip
}

output "uploads_bucket_name" {
  description = "Nom du bucket S3 pour les uploads"
  value       = aws_s3_bucket.uploads.bucket
}

output "static_bucket_name" {
  description = "Nom du bucket S3 pour les fichiers statiques"
  value       = aws_s3_bucket.static.bucket
}

output "static_bucket_url" {
  description = "URL du bucket S3 statique"
  value       = "https://${aws_s3_bucket.static.bucket}.s3.amazonaws.com"
}
