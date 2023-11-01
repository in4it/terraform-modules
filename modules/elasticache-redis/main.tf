locals {
  name = var.override_name ? var.name : "${var.name}-${var.env}-${var.name_suffix}"
  parameters = concat(var.parameters, var.cluster_mode_enabled == false ? [] : [
    {
      name  = "cluster-enabled", # Needed for cluster mode and autoscaling
      value = "yes"
    }
  ])
  tags = merge({
    Name        = "${var.name}-${var.env}-${var.name_suffix}"
    Environment = var.env
  }, var.tags)
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_elasticache_subnet_group" "redis" {
  count = var.existing_subnet_group == "" ? 1 : 0

  name       = "${local.name}-subg"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis" {
  count = var.existing_security_group == "" ? 1 : 0

  name        = "${local.name}-sg"
  description = "Security group for ${local.name}"
  vpc_id      = data.aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      description      = try(ingress.value.description, "")
      security_groups  = try(ingress.value.security_groups, [])
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(ingress.value.prefix_list_ids, [])
      self             = try(ingress.value.self, false)
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }
}

# Redis Cluster
resource "aws_elasticache_parameter_group" "redis" {
  count = var.existing_parameter_group == "" ? 1 : 0

  name        = "${local.name}-pg"
  description = "Elasticache parameter group for ${local.name}"
  family      = var.family

  dynamic "parameter" {
    for_each = local.parameters
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }
  tags = local.tags
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = local.name
  description          = "Redis Cluster for ${local.name}"

  node_type               = var.redis_node_type
  num_node_groups         = var.redis_shard_number
  replicas_per_node_group = var.replicas_per_node_group
  multi_az_enabled        = var.multi_az_enabled

  engine_version       = var.engine_version
  port                 = var.port
  parameter_group_name = var.existing_parameter_group != "" ? var.existing_parameter_group : aws_elasticache_parameter_group.redis[0].name

  subnet_group_name  = var.existing_subnet_group != "" ? var.existing_subnet_group : aws_elasticache_subnet_group.redis[0].name
  security_group_ids = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.redis[0].id]

  at_rest_encryption_enabled = var.rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  maintenance_window         = var.maintenance_window
  automatic_failover_enabled = true
  apply_immediately          = var.apply_immediately
  data_tiering_enabled       = strcontains(var.redis_node_type, "r6gd")
  auto_minor_version_upgrade = true

  tags = local.tags

  lifecycle {
    ignore_changes = [
      security_group_names, # bug in AWS provider that wants to recreate the resource
    ]
  }
}
data "aws_security_group" "existing" {
  count = var.existing_security_group != "" ? 1 : 0

  id = var.existing_security_group
}
