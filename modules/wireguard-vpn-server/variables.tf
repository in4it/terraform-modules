variable "instance_type" {
    default = "t3.small"
}

variable "vpc_id" {
    description = "VPC id to launch the VPN Server in"

}
variable "instance_subnet_id" {
    description = "subnet to launch the VPN Server in"
}

variable "instance_profile_name" {
    default     = ""
    description = "use a custom instance profile"
}

variable "efs_subnet_ids" {
    description = "subnets to create the efs mountpoints in"
}

variable "env" {
    default = "prod"
}

variable "listeners" {
  type = list(object({
    port        = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    port        = "51820"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    port        = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    port        = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
    default = {}
    type = map(string)
}

variable "ami_owner" {
    default = "aws-marketplace"
}

variable "license" {
    default = "marketplace"
}
