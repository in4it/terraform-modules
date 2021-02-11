# kms key kinesis
resource "aws_kms_key" "kinesis-kms" {
  count                   = var.kinesis_stream_encryption == true ? 1 : 0
  description             = var.kms_kinesis_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.kinesis_enable_key_rotation
}

resource "aws_kms_alias" "kinesis-kms" {
  count         = var.kinesis_stream_encryption == true ? 1 : 0
  name          = "alias/${var.kinesis_stream_name}"
  target_key_id = aws_kms_key.kinesis-kms[0].key_id
}

# kms key s3
resource "aws_kms_key" "s3-kms" {
  count                   = var.s3_bucket_sse == true && var.enable_kinesis_firehose == true ? 1 : 0
  description             = var.kms_s3_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.s3_enable_key_rotation
}

resource "aws_kms_alias" "s3-kms" {
  count         = var.s3_bucket_sse == true && var.enable_kinesis_firehose == true ? 1 : 0
  name          = "alias/${var.bucket_name}"
  target_key_id = aws_kms_key.s3-kms[0].key_id
}