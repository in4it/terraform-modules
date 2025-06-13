variable "name" {
  description = "Name prefix for the ElastiCache Valkey cluster"
}
variable "env" {
  description = "Deployment environment : dev | stg | prod  etc.."
}
variable "name_suffix" {
  default     = "valkey"
  description = "Suffix for the ElastiCache Valkey cluster name"
}
variable "override_name" {
  type        = bool
  default     = false
  description = "Override name for existing clusters to not recreate the cluster"
}
variable "vpc_id" {
  description = "VPC to deploy the new cluster"
}
variable "subnet_ids" {
  description = "List of Subnet IDs to deploy the new cluster"
  type        = list(string)
}
variable "ingress_rules" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    security_groups  = optional(list(string))
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    description      = optional(string)
    prefix_list_ids  = optional(list(string))
    self             = optional(bool)
  }))
}
variable "family" {
  default = "valkey8"
  description = "The family of the ElastiCache parameter group. For Valkey, use 'valkey8'"
}
variable "engine_version" {
  default = "8.0"
  description = "The version number of the Valkey engine"
}
variable "cluster_mode_enabled" {
  default = true
}
variable "port" {
  description = "Valkey Cluster port"
  default     = 6379
}
variable "parameters" {
  default = [
    {
      name  = "maxmemory-policy"
      value = "volatile-lru"
    },
    {
      name  = "maxmemory-samples"
      value = "10"
    },
    {
      name  = "timeout"
      value = "0"
    }
  ]
  description = "Values for the parameters in the parameter group"
  type = list(object({
    name  = string
    value = string
  }))
}
variable "tags" {
  default     = {}
  description = "Tags for all resources"
  type        = map(string)
}
variable "valkey_node_type" {
  type        = string
  default     = "cache.t4g.micro"
  description = "The compute and memory capacity of the nodes. For Valkey, supported node types include cache.t4g.micro, cache.t4g.small, cache.t4g.medium, cache.r6g.large, cache.r6g.xlarge, cache.r6g.2xlarge, cache.r6g.4xlarge, cache.r6g.8xlarge, cache.r6g.12xlarge, cache.r6g.16xlarge, cache.r6g.24xlarge, cache.r7g.large, cache.r7g.xlarge, cache.r7g.2xlarge, cache.r7g.4xlarge, cache.r7g.8xlarge, cache.r7g.12xlarge, cache.r7g.16xlarge, cache.r7g.24xlarge"
}
variable "valkey_shard_number" {
  default     = 1
  type        = number
  description = "Number of shards (node groups) in the cluster"
}
variable "replicas_per_node_group" {
  description = "Number of replica nodes in each node group. Valid values are 0 to 5."
  default     = 0
}
variable "multi_az_enabled" {
  description = "Enable Multi-AZ Support"
  default     = false
}
variable "apply_immediately" {
  default = false
  type    = bool
}
variable "transit_encryption_enabled" {
  default = true
  type    = bool
}
variable "rest_encryption_enabled" {
  default = true
  type    = bool
}
variable "maintenance_window" {
  default = "sun:05:00-sun:06:00"
}
variable "existing_subnet_group" {
  default     = ""
  description = "Use existing subnet group name (for resources import)"
}
variable "existing_security_group" {
  default     = ""
  description = "Use existing security group id (for resources import)"
}
variable "existing_parameter_group" {
  default     = ""
  description = "Use existing parameter group (for resources import)"
}
variable "log_delivery_configurations" {
  default = []
  description = "List of log delivery configurations"
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
}
variable "auto_minor_version_upgrade" {
  default     = true
  type        = bool
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window"
}
variable "snapshot_retention_limit" {
  default     = 5
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. Set to 0 to disable backups"
}
variable "snapshot_window" {
  default     = "03:00-05:00"
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster"
}
variable "notification_topic_arn" {
  default     = ""
  type        = string
  description = "An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to"
}
variable "auth_token" {
  default     = null
  type        = string
  sensitive   = true
  description = "The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true"
}