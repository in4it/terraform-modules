variable "name" {
  description = "Name prefix for the Elasticache cluster"
}
variable "env" {
  description = "Deployment environment : dev | stg | prod  etc.."
}
variable "name_suffix" {
  default     = "redis"
  description = "Suffix for the Elasticache cluster name"
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
  default = "redis7"
}
variable "engine_version" {
  default = "7.0"
}
variable "cluster_mode_enabled" {
  default = true
}
variable "port" {
  description = "Redis Cluster port"
  default     = 6379
}
variable "parameters" {
  default     = []
  description = "values for the parameters in the parameter group"
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
variable "redis_node_type" {
  type        = string
  default     = "cache.t4g.micro"
  description = "[supported node types](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html) and [guidance on selecting node types](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/nodes-select-size.html)."
}
variable "redis_shard_number" {
  default     = 1
  type        = number
  description = "aka num_node_groups"
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
