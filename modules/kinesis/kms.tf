# kms key kinesis
resource "aws_kms_key" "kinesis-kms" {
  count                   = var.kinesis_stream_encryption == true ? 1 : 0
  description             = "${var.kms_description} kinesis key"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
}

resource "aws_kms_alias" "kinesis-kms" {
  count         = var.kinesis_stream_encryption == true ? 1 : 0
  name          = "alias/${var.name}-kinesis"
  target_key_id = aws_kms_key.kinesis-kms[0].key_id
}

# kms key s3
resource "aws_kms_key" "s3-kms" {
  count                   = var.s3_bucket_sse == true && var.enable_kinesis_firehose == true ? 1 : 0
  description             = "${var.kms_description} s3 key"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
}

resource "aws_kms_alias" "s3-kms" {
  count         = var.s3_bucket_sse == true && var.enable_kinesis_firehose == true ? 1 : 0
  name          = "alias/${var.name}-s3"
  target_key_id = aws_kms_key.s3-kms[0].key_id
}