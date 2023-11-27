variable "identifier" {
  default = "site2site"
}
variable "instance_type" {
    default = "t3.micro"
}

variable "source_dest_check" {
  default = false
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
    port        = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    port        = "51820"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
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

variable "tags" {
    default = {}
    type = map(string)
}
