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
  alb_name           = "my-alb"
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