variable "project_name" {
  type = string
}
variable "env" {
  type = string
}

#Domains
variable "vpn_domain" {
  type = string
}
variable "app_domain" {
  type = string
}

#CA
variable "certificate_organization_name" {
  description = "The name of the organization used to generate the Certificate Authority"
  type        = string
}
variable "cert_req_email" {
  type = string
}
variable "cert_req_city" {
  type = string
}
variable "cert_req_province" {
  type = string
}
variable "cert_req_country" {
  type        = string
  description = "Two letters id of the country. Eg: EN"
}
variable "organization_name" {
  type = string
}

#oauth2
variable "ouath2_client_secret_parameter_arn" {
  type        = string
  description = "ARN of the SSM Parameter or Secret Manager's Secret containing the OAUTH2 client secret"
}
variable "ouath2_client_id_parameter_arn" {
  type        = string
  description = "ARN of the SSM Parameter or Secret Manager's Secret containing the OAUTH2 client id"
}
variable "oauth2_url" {
  type = string
}
variable "csrf_key_parameter_arn" {
  type        = string
  description = "ARN of the SSM Parameter or Secret Manager's Secret containing the CSRF key"
}

#VPC
variable "vpc_id" {
  type = string
}
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets to host the OpenVPN-access service on Fargate"
}
variable "public_subnets" {
  type        = list(string)
  description = "Public subnets to host the OpenVPN server"
}

#ALB
variable "alb_arn" {
  type        = string
  description = "The ARN of the ALB used to expose the OpenVPN-access service on Fargate"
}
variable "alb_security_group_id" {
  type        = string
  description = "The ID of the ALB Security Group"
}
variable "alb_https_listener_arn" {
  type = string
}
variable "alb_dns_name" {
  default = ""
  type    = string
}
variable "alb_dns_zone_id" {
  default = ""
  type    = string
}
variable "alb_route_priority" {
  default = 10
}

#DNS
variable "hosted_zone_id" {
  type        = string
  default     = ""
  description = "The module will create records for both the OpenVPN instance and for the ALB for OpenVPN access"
}

#EC2
variable "instance_type" {
  type    = string
  default = "t3.nano"
}

#Onelogin
variable "onelogin_client_id" {
  type = string
}
variable "onelogin_client_secret" {
  type        = string
  description = "Safe to store in git, because it allows only logins"
}
variable "onelogin_client_domain" {
  type = string
}

#VPN
variable "open_vpn_client_file_base64" {
  type        = string
  description = "Base64 content of the vpn-client file. An example of this file can be found inside the moduledir/tpl/openvpn-client.tpl"
}

#Public ECR
variable "openvpn_public_ecr" {
  type = string
}
variable "openvpn_access_public_ecr" {
  type = string
}

variable "create_r53_records" {
  default = false
  type    = bool
}

#VPN
variable "listeners" {
  type = list(object({
    port     = string
    protocol = string
  }))
}

variable "log_retention_days" {
  default = 0
}