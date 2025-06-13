output "endpoint" {
  value = var.cluster_mode_enabled == false ? aws_elasticache_replication_group.this.primary_endpoint_address : aws_elasticache_replication_group.this.configuration_endpoint_address
}
output "security_group_id" {
  value = var.existing_security_group == "" ? aws_security_group.this[0].id : var.existing_security_group
}
