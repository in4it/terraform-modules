moved {
  from = aws_elasticache_parameter_group.redis
  to   = aws_elasticache_parameter_group.this
}
moved {
    from = aws_elasticache_replication_group.redis
    to   = aws_elasticache_replication_group.this
}
moved {
  from = aws_elasticache_subnet_group.redis
  to   = aws_elasticache_subnet_group.this
}
moved {
  from = aws_security_group.redis
  to   = aws_security_group.this
}
