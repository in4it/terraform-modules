output "kinesis_kms_arn" {
  value = aws_kms_key.kinesis-kms[0].arn
}

output "kinesis_arn" {
  value = aws_kinesis_stream.kinesis-stream.arn
}

output "kinesis_name" {
  value = aws_kinesis_stream.kinesis-stream.name
}

output "s3_arn" {
  value = aws_s3_bucket.s3-bucket[0].arn
}

output "s3_id" {
  value = aws_s3_bucket.s3-bucket[0].id
}

output "s3_kms_arn" {
  value = aws_kms_key.s3-kms[0].arn
}

output "iam_firehose_role_arn" {
  value = aws_iam_role.iam-firehose-role[0].arn
}

output "iam_firehose_role_id" {
  value = aws_iam_role.iam-firehose-role[0].id
}

output "aws_region_name" {
  value = data.aws_region.current.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}