# LB logs

data "aws_elb_service_account" "main" {
  count = length(var.access_logs)
}

resource "aws_s3_bucket" "lb_logs" {
  count  = length(var.access_logs)
  bucket = "${var.lb_name}-lb-logs"

  tags = {
    Name = "${var.lb_name}-lb-logs"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lb_logs" {
  count  = length(var.access_logs)
  bucket = aws_s3_bucket.lb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "lb_logs" {
  count  = length(var.access_logs)
  bucket = aws_s3_bucket.lb_logs[0].id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "lb_logs" {
  count  = length(var.access_logs)
  bucket = aws_s3_bucket.lb_logs[0].id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "logs-policy",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "${data.aws_elb_service_account.main[0].arn}"
          ]
        },
        "Action": "s3:PutObject",
        "Resource": [
          "arn:aws:s3:::${var.lb_name}-lb-logs/AWSLogs/*"
        ]
      },
      {
        "Sid": "AllowSSLRequestsOnly",
        "Action": "s3:*",
        "Effect": "Deny",
        "Resource": [
          "arn:aws:s3:::${var.lb_name}-lb-logs",
          "arn:aws:s3:::${var.lb_name}-lb-logs/*"
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

resource "aws_s3_bucket_public_access_block" "lb-logs" {
  count  = length(var.access_logs)
  bucket = aws_s3_bucket.lb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
