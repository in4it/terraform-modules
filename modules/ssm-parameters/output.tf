output "kms-key-id" {
  value = length(aws_kms_key.ssm-parameters) > 0 ? aws_kms_key.ssm-parameters[0].key_id : null
}
output "kms-key-arn" {
  value = length(aws_kms_key.ssm-parameters) > 0 ? aws_kms_key.ssm-parameters[0].arn : null
}
