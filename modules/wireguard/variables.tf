variable "instance_type" {
    default = "t3.micro"
}
variable "db_instance_type" {
    default = "db.t4g.micro"
}
variable "vpc_id" {

}
variable "instance_subnet_id" {
    description = "subnet to launch the EC2 in"
}
variable "db_subnet_ids" {
    description = "subnets to launch the DB in"
}
variable "efs_subnet_ids" {
    description = "subnets to create the efs mountpoints in"
}
variable "external_url" {
    description = "external url the VPN is going to be reachable over. Starts with https://"
}
variable "admin_email" {
    description = "email of administrator"
}
variable "log_retention_days" {
    default = 30
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

variable "env" {
    default = "prod"
}

variable "tags" {
    default = {}
    type = map(string)
}
variable "db_engine_version" {
  default = "15.5"
}