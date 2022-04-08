// based original code https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/v1.2.2 and https://github.com/snowplow-devops/terraform-aws-dynamodb-autoscaling/tree/release/0.1.2

variable "create_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = true
}

variable "table_name" {
  description = "The name of the DynamoDB table to add auto-scaling to"
  type        = string
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: table_name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery"
  type        = bool
  default     = false
}

variable "ttl_enabled" {
  description = "Indicates whether ttl is enabled"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = ""
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type        = any
  default     = []
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  type        = any
  default     = []
}

variable "replica_regions" {
  description = "Region names for creating replicas for a global DynamoDB table."
  type        = any
  default     = []
}

variable "stream_enabled" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type        = string
  default     = null
}

variable "server_side_encryption_enabled" {
  description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)"
  type        = bool
  default     = false
}

variable "server_side_encryption_kms_key_arn" {
  description = "The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default = {
    create = "10m"
    update = "60m"
    delete = "10m"
  }
}

variable "autoscaling_enabled" {
  description = "Whether or not to enable autoscaling. "
  type        = bool
  default     = false
}

variable "autoscaling_indexes" {
  description = "A map of index autoscaling configurations."
  type        = map(map(string))
  default     = {}
}

variable "as_read_min_capacity" {
  description = "The minimum READ capacity for the table"
  type        = number
  default     = 1
}

variable "as_read_max_capacity" {
  description = "The maximum READ capacity for the table"
  type        = number
  default     = 30
}

variable "as_read_target_value" {
  description = "The target utilization percentage for the table"
  type        = number
  default     = 70
}

variable "as_read_scale_in_cooldown" {
  description = "The number of seconds before scaling IN can occur after a scaling action"
  type        = number
  default     = 300
}

variable "as_read_scale_out_cooldown" {
  description = "The number of seconds before scaling OUT can occur after a scaling action"
  type        = number
  default     = 20
}

variable "as_write_min_capacity" {
  description = "The minimum WRITE capacity for the table"
  type        = number
  default     = 1
}

variable "as_write_max_capacity" {
  description = "The maximum WRITE capacity for the table"
  type        = number
  default     = 30
}

variable "as_write_target_value" {
  description = "The target utilization percentage for the table"
  type        = number
  default     = 75
}

variable "as_write_scale_in_cooldown" {
  description = "The number of seconds before scaling IN can occur after a scaling action"
  type        = number
  default     = 300
}

variable "as_write_scale_out_cooldown" {
  description = "The number of seconds before scaling OUT can occur after a scaling action"
  type        = number
  default     = 30
}
