# Bucket pour les uploads
resource "aws_s3_bucket" "uploads" {
  bucket = "${var.project_name}-uploads-${random_id.bucket_suffix.hex}"
}

# Bucket pour les fichiers statiques
resource "aws_s3_bucket" "static" {
  bucket = "${var.project_name}-static-${random_id.bucket_suffix.hex}"
}

# Configuration publique pour le bucket static
resource "aws_s3_bucket_public_access_block" "static" {
  bucket = aws_s3_bucket.static.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Politique pour rendre le bucket static public
resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.static]
}

# Random ID pour éviter les conflits de noms de buckets
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
