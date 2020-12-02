resource "aws_ssm_parameter" "parameters" {
  for_each = { for p in var.parameters : p.name => p }
  name     = "${var.prefix}${each.key}"
  type     = each.value.type
  value    = each.value.value
  key_id   = var.at_rest_encryption ? aws_kms_key.ssm-parameters[0].id : ""
}

