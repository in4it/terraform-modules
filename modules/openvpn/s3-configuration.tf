resource "aws_s3_bucket" "configuration-bucket" {
  bucket = "${var.project_name}-configuration-${var.env}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "configuration-bucket" {
  bucket = aws_s3_bucket.configuration-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "configuration-bucket" {
  bucket = aws_s3_bucket.configuration-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "configuration-bucket" {
  bucket = aws_s3_bucket.configuration-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "configuration-bucket" {
  bucket = aws_s3_bucket.configuration-bucket.id
  policy = <<EOF
{
  "Id": "S3Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSSLRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": [
        "arn:aws:s3:::${var.project_name}-configuration-${var.env}",
        "arn:aws:s3:::${var.project_name}-configuration-${var.env}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF
}