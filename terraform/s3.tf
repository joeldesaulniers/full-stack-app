# S3 Bucket Creation
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket_prefix = "techtask-bucket-"

  tags = {
    Name        = "My bucket"
    Environment = "Sandbox"
  }
}

# Enable Versioning for S3 Bucket
resource "aws_s3_bucket_versioning" "my_s3_bucket-versioning" {
  bucket = aws_s3_bucket.my_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create Backup Folder in S3 Bucket
resource "aws_s3_object" "backup_folder" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  key    = "DB-backups/"
}

# Optional: Block public access
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.my_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
