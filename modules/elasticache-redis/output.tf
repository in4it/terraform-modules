output "endpoint" {
  value = var.cluster_mode_enabled == false ? aws_elasticache_replication_group.redis.primary_endpoint_address : aws_elasticache_replication_group.redis.configuration_endpoint_address
}
output "redis_security_group_id" {
  value = var.existing_security_group == "" ? aws_security_group.redis[0].id : var.existing_security_group
}
