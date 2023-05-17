variable "identifier" {
  default = "site2site"
}
variable "instance_type" {
    default = "t3.micro"
}

variable "vpc_id" {

}
variable "instance_subnet_id" {
    description = "subnet to launch the EC2 in"
}
variable "log_retention_days" {
    default = 30
}

variable "listeners" {
  type = list(object({
    port     = string
    protocol = string
  }))
  default = [{
    port     = "51820"
    protocol = "udp"
  }]
}

variable "env" {
    default = "prod"
}

variable "vpn_internal_cidr" {

}
variable "vpn_destination_allowed_ips" {

}
variable "vpn_destination_pubkey" {

}
variable "vpn_destination_public_ip" {

}