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
    Engine      = "valkey"
  }, var.tags)
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_elasticache_subnet_group" "valkey" {
  count = var.existing_subnet_group == "" ? 1 : 0

  name       = "${local.name}-subg"
  subnet_ids = var.subnet_ids
  
  tags = local.tags
}

resource "aws_security_group" "valkey" {
  count = var.existing_security_group == "" ? 1 : 0

  name        = "${local.name}-sg"
  description = "Security group for ${local.name} Valkey cluster"
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
    description = "Allow all outbound traffic within VPC"
  }
  
  tags = local.tags
}

# Valkey Cluster
resource "aws_elasticache_parameter_group" "valkey" {
  count = var.existing_parameter_group == "" ? 1 : 0

  name        = "${local.name}-pg"
  description = "ElastiCache parameter group for ${local.name} Valkey cluster"
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

resource "aws_elasticache_replication_group" "valkey" {
  replication_group_id = local.name
  description          = "Valkey Cluster for ${local.name}"

  # Engine configuration
  engine         = "valkey"
  engine_version = var.engine_version
  port           = var.port

  # Node configuration
  node_type               = var.valkey_node_type
  num_node_groups         = var.valkey_shard_number
  replicas_per_node_group = var.replicas_per_node_group
  
  # High availability
  multi_az_enabled           = var.multi_az_enabled
  automatic_failover_enabled = var.multi_az_enabled || var.valkey_shard_number > 1 # Enable automatic failover for multi-AZ or multi-shard clusters
  
  # Network configuration
  parameter_group_name = var.existing_parameter_group != "" ? var.existing_parameter_group : aws_elasticache_parameter_group.valkey[0].name
  subnet_group_name    = var.existing_subnet_group != "" ? var.existing_subnet_group : aws_elasticache_subnet_group.valkey[0].name
  security_group_ids   = var.existing_security_group != "" ? [var.existing_security_group] : [aws_security_group.valkey[0].id]

  # Security
  at_rest_encryption_enabled = var.rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null
  
  # Backup and maintenance
  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window         = var.snapshot_window != "" ? var.snapshot_window : null
  maintenance_window      = var.maintenance_window
  
  # Performance and scaling
  data_tiering_enabled       = strcontains(var.valkey_node_type, "r6gd") || strcontains(var.valkey_node_type, "r7gd")
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  
  # Notifications
  notification_topic_arn = var.notification_topic_arn != "" ? var.notification_topic_arn : null

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configurations
    
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type  
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      security_group_names, # bug in AWS provider that wants to recreate the resource
      auth_token,          # Ignore auth token changes to prevent recreation
    ]
  }
}

data "aws_security_group" "existing" {
  count = var.existing_security_group != "" ? 1 : 0

  id = var.existing_security_group
}
