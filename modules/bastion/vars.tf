variable "name" {
  description = "name of the bastion"
  default     = "bastion"
}
variable "vpc_id" {
  description =" vpc id"
}
variable "subnet_id" {
  description = "subnet id to launch bastion in"
}
variable "instance_type" {
  description = "bastion instance type"
}
variable "ingress_cidr" {
  description = "bastion ingress cidr block to allow"
}
variable "keypair_name" {
  description = "name of the ssh keypair to use"
}
variable "root_block_device_encryption" {
  description = "encrypt root block device"
  default     = true
}
