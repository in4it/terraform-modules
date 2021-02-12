resource "aws_kinesis_stream" "kinesis-stream" {
  name             = var.environment == "" ? "${var.name}-kinesis" : "${var.name}-kinesis-${var.environment}"
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period
  shard_level_metrics = [
    "OutgoingRecords",
    "IncomingRecords",
  ]

  encryption_type = var.kinesis_stream_encryption == true ? "KMS" : "NONE"
  kms_key_id      = var.kinesis_stream_encryption == true ? aws_kms_key.kinesis-kms[0].arn : ""
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis-firehose" {
  count       = var.enable_kinesis_firehose == true ? 1 : 0
  name        = var.environment == "" ? "${var.name}-firehose"  : "${var.name}-firehose-${var.environment}"
  destination = var.kinesis_firehose_destination

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis-stream.arn
    role_arn           = aws_iam_role.iam-firehose-role[0].arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.iam-firehose-role[0].arn
    bucket_arn = aws_s3_bucket.s3-bucket[0].arn

    compression_format = var.firehose_s3_compression_format
    buffer_size        = "5"
    buffer_interval    = "300"
    kms_key_arn        = var.s3_bucket_sse == true ? aws_kms_key.s3-kms[0].arn : ""
  }
}