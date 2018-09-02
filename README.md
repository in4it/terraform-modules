# terraform-modules
repository of useful terraform modules

# Usage

## ECS Cluster
```
module "my-ecs" {
  source         = "github.com/in4it/terraform-modules//modules/ecs-cluster"
  VPC_ID         = "vpc-id"
  CLUSTER_NAME   = "my-ecs"
  INSTANCE_TYPE  = "t2.small"
  SSH_KEY_NAME   = "mykeypairName"
  VPC_SUBNETS    = "subnetId-1,subnetId-2"
  ENABLE_SSH     = true
  SSH_SG         = "my-ssh-sg"
  LOG_GROUP      = "my-log-group"
  AWS_ACCOUNT_ID = "1234567890"
  AWS_REGION     = "us-east-1"
}
```

## ECS Service
```
module "my-service" {
  source              = "github.com/in4it/terraform-modules//modules/ecs-service"
  VPC_ID              = "vpc-id"
  APPLICATION_NAME    = "my-service"
  APPLICATION_PORT    = "8080"
  APPLICATION_VERSION = "latest"
  CLUSTER_ARN         = "${module.my-ecs.cluster_arn}"
  SERVICE_ROLE_ARN    = "${module.my-ecs.service_role_arn}"
  AWS_REGION          = "us-east-1"
  HEALTHCHECK_MATCHER = "200"
  CPU_RESERVATION     = "1024"
  MEMORY_RESERVATION  = "1024"
  LOG_GROUP           = "my-log-group"
  DESIRED_COUNT       = 2
  ALB_ARN             = "${module.my-alb.alb_arn}"
}
```

## ALB
```
module "my-alb" {
  source             = "github.com/in4it/terraform-modules/modules/alb"
  VPC_ID             = "vpc-id"
  ALB_NAME           = "my-alb"
  VPC_SUBNETS        = "subnetId-1,subnetId-2"
  DEFAULT_TARGET_ARN = "${module.my-service.target_group_arn}"
  DOMAIN             = "*.my-ecs.com"
  INTERNAL           = false
  ECS_SG             = "${module.my-ecs.cluster_sg}"
}
```

## ALB Rule
```
module "my-alb-rule" {
  source             = "github.com/in4it/terraform-modules/modules/alb-rule"
  LISTENER_ARN       = "${module.my-alb.http_listener_arn}"
  PRIORITY           = 100
  TARGET_GROUP_ARN   = "${module.my-service.target_group_arn}"
  CONDITION_FIELD    = "host-header"
  CONDITION_VALUES   = ["subdomain.my-ecs.com"]
}
```
