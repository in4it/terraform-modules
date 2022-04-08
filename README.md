# terraform-modules
repository of useful terraform modules

# Usage


## ECS Cluster (EC2)
```
module "my-ecs" {
  source         = "github.com/in4it/terraform-modules//modules/ecs-cluster"
  vpc_id         = "vpc-id"
  cluster_name   = "my-ecs"
  instance_type  = "t2.small"
  ssh_key_name   = "mykeypairName"
  vpc_subnets    = "subnetId-1,subnetId-2"
  enable_ssh     = true
  ssh_sg         = "my-ssh-sg"
  log_group      = "my-log-group"
  aws_account_id = "1234567890"
  aws_region     = "us-east-1"
}
```

## ECS Cluster (Fargate)
```
module "my-ecs" {
  source         = "github.com/in4it/terraform-modules//modules/fargate-cluster"
  cluster_name   = "my-ecs"
  log_group      = "my-log-group"
}
```

## ECS Service
```
module "my-service" {
  source              = "github.com/in4it/terraform-modules//modules/ecs-service"
  vpc_id              = "vpc-id"
  application_name    = "my-service"
  application_port    = "8080"
  application_version = "latest"
  cluster_arn         = "${module.my-ecs.cluster_arn}"
  service_role_arn    = "${module.my-ecs.service_role_arn}"
  aws_region          = "us-east-1"
  healthcheck_matcher = "200"
  cpu_reservation     = "1024"
  memory_reservation  = "1024"
  log_group           = "my-log-group"
  desired_count       = 2
  alb_arn             = "${module.my-alb.alb_arn}"
  launch_type         = "FARGATE"
  security_groups     = [""]
  subnets             = [""]
}
```

## ALB
```
module "my-alb" {
  source             = "github.com/in4it/terraform-modules/modules/alb"
  vpc_id             = "vpc-id"
  lb_name            = "my-alb"
  vpc_subnets        = "subnetId-1,subnetId-2"
  default_target_arn = "${module.my-service.target_group_arn}"
  domain             = "*.my-ecs.com"
  internal           = false
  ecs_sg             = "${module.my-ecs.cluster_sg}"
}
```

## ALB Rule
```
module "my-alb-rule" {
  source             = "github.com/in4it/terraform-modules/modules/alb-rule"
  listener_arn       = "${module.my-alb.http_listener_arn}"
  priority           = 100
  target_group_arn   = "${module.my-service.target_group_arn}"
  condition_field    = "host-header"
  condition_values   = ["subdomain.my-ecs.com"]
}
```

## Kinesis

### Example with mandatory parameters
```
module "my-kinesis" {
  name = "my-name"
}
```

### Example with advance parameters
```
module "my-kinesis" {
  name = "my-name"
  kms_description = "My description"
  environment = "my-env"
  kinesis_stream_encryption = true
  kinesis_shard_count = 1
  kinesis_retention_period = 24
  kms_deletion_window_in_days = 30
  kms_enable_key_rotation = true
  enable_kinesis_firehose = true
  firehose_s3_compression_format = "GZIP"
  kinesis_firehose_destination = "s3"
  s3_bucket_sse = true
  vpcs_restriction_list = [my-vpcs]
  s3_deletion_protection =  true
  s3_vpc_restriction_exception_roles = [my-exception-roles]
}

```
## Dynamodb
```
module "dynamodb_table" {
  source                 = "my-dynamodb"
  table_name             = "example-table"
  hash_key               = "id"
  autoscaling_enabled    = "false"
  stream_enabled         = "false"
  range_key              = "S"
  billing_mode           = "PROVISIONED"
  read_capacity          = "1"
  write_capacity         = "1"
  point_in_time_recovery = "false"
  ttl_enabled            = "false"
  ttl_attribute_name     = "ttl"
  global_secondary_indexes {
    name      = "index_name"
    hash_key  = "S"
    range_key = "S"
  }
  local_secondary_indexes {
    name      = "index_name"
    hash_key  = "S"
    range_key = "S"
  }
  replica_regions {
    region_name = "us-east-1"
  }

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
  server_side_encryption             = "false"
  server_side_encryption_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  # Only enable with autoscaling_enabled = "true"

  autoscaling_indexes {
    index_name                          = "index_name"
    read_capacity_auto_scaling_trigger  = "1"
    write_capacity_auto_scaling_trigger = "1"
  }

  as_read_min_capacity        = "1"
  as_write_min_capacity       = "1"
  as_read_max_capacity        = "50"
  as_write_max_capacity       = "50"
  as_read_target_value        = "80"
  as_read_scale_in_cooldown   = "300"
  as_read_scale_out_cooldown  = "30"
  as_write_target_value       = "80"
  as_write_scale_in_cooldown  = "300"
  as_write_scale_out_cooldown = "30"
}
```

## AWS SFTP Transfer

```
module "transfer" {
  transfer_server_name       = "transfer-server"
  transfer_server_user_names = ["sftp-user-name-01", "sftp-user-name-02"]
  transfer_server_ssh_keys   = [file("../../data/ssh/example-key-sftp-01-${var.env}.pub"),file("../../data/ssh/example-key-sftp-02-${var.env}.pub")]
  bucket_name                = aws_s3_bucket.transfer-bucket.id
  bucket_arn                 = aws_s3_bucket.transfer-bucket.arn
}
```

## OpenVPN

```
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myclient-dev"
  cidr = "10.1.0.0/16"

  azs              = ["eu-west-1a","eu-west-1b"]
  private_subnets  = ["10.1.4.0/24", "10.1.5.0/24"]
  public_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]
  database_subnets = ["10.1.7.0/24", "10.1.8.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_dhcp_options  = true

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  single_nat_gateway     = true
}

module "alb" {
  source      = "git@github.com:in4it/terraform-modules.git//modules/alb"
  vpc_id      = module.vpc.vpc_id
  lb_name     = "myclient-dev"
  vpc_subnets = module.vpc.public_subnets
  domain      = "example.com"
  internal    = false

  tls = true

  tls_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  access_logs = {
    enabled = "true"
  }
}

module "vpn" {
  source         = "git@github.com:in4it/terraform-modules.git//modules/openvpn"
  env            = "dev"
  domain         = "example.com"
  project_name   = "my_client"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  hosted_zone_id = data.terraform_remote_state.dns.outputs.primary-hosted-zone

  alb_arn                = module.alb.lb-arn
  alb_dns_name           = module.alb.dns_name
  alb_dns_zone_id        = module.alb.zone_id
  alb_https_listener_arn = module.alb.https-listener-arn
  alb_security_group_id  = module.alb.security-group-id

  cert_req_city                 = "London"
  cert_req_country              = "EN"
  cert_req_email                = "admin@my_client.com"
  cert_req_province             = "London"
  certificate_organization_name = "my_client"
  organization_name             = "my_client"

  csrf_key_parameter_arn             = "arn:aws:ssm:eu-west-1:0123456789:parameter/my_client-dev/vpn/CSRF_KEY"
  onelogin_client_domain             = "my_client"
  onelogin_client_id                 = var.onelogin_client_id
  onelogin_client_secret             = var.onelogin_client_secret
  open_vpn_client_file_base64        = base64encode(data.template_file.openvpn-client.rendered)
  ouath2_client_id_parameter_arn     = "arn:aws:ssm:eu-west-1:0123456789:parameter/my_client-dev/vpn/OAUTH2_CLIENT_ID"
  ouath2_client_secret_parameter_arn = "arn:aws:ssm:eu-west-1:0123456789:parameter/my_client-dev/vpn/OAUTH2_CLIENT_SECRET"
  oauth2_url                         = "https://my_client.onelogin.com/oidc/2"

  openvpn_public_ecr        = "public.ecr.aws/y9x3p3i6/openvpn"
  openvpn_access_public_ecr = "public.ecr.aws/y9x3p3i6/openvpn-access"
}
```
