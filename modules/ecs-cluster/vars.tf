variable "AWS_ACCOUNT_ID" {
}

variable "AWS_REGION" {
}

variable "LOG_GROUP" {
}

variable "VPC_ID" {
}

variable "CLUSTER_NAME" {
}

variable "INSTANCE_TYPE" {
}

variable "SSH_KEY_NAME" {
}

variable "VPC_SUBNETS" {
}

variable "ECS_TERMINATION_POLICIES" {
  default = "OldestLaunchConfiguration,Default"
}

variable "ECS_MINSIZE" {
  default = 1
}

variable "ECS_MAXSIZE" {
  default = 1
}

variable "ECS_DESIRED_CAPACITY" {
  default = 1
}

variable "ENABLE_SSH" {
  default = false
}

variable "SSH_SG" {
  default = ""
}

