# S3 bucket for remote state
resource "aws_s3_bucket" "app_spec" {
  bucket = "app-spec-bucket-ecs"
  lifecycle { prevent_destroy = true }
  tags = { Name = "AppSpecBucket"}
}


resource "aws_s3_bucket_versioning" "app_spec" {
  bucket = aws_s3_bucket.app_spec.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_spec" {
  bucket = aws_s3_bucket.app_spec.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "app_spec" {
  bucket = aws_s3_bucket.app_spec.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "app_spec_bucket"  { value = aws_s3_bucket.app_spec.bucket }