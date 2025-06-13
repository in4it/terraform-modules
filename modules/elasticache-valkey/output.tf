output "endpoint" {
  value = var.cluster_mode_enabled == false ? aws_elasticache_replication_group.valkey.primary_endpoint_address : aws_elasticache_replication_group.valkey.configuration_endpoint_address
}

output "valkey_security_group_id" {
  value = var.existing_security_group == "" ? aws_security_group.valkey[0].id : var.existing_security_group
}
