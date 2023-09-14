module "service" {
  source                    = "git@github.com:in4it/terraform-modules.git//modules/ecs-service?ref=f96d1e1d3cd15e0576ba159cc4832df9b2adf965"
  application_name          = var.service_name
  application_port          = var.application_port
  application_version       = "latest"
  aws_region                = var.aws_region
  platform_version          = var.platform_version
  cluster_arn               = data.aws_ecs_cluster.this.arn
  vpc_id                    = var.vpc_id
  fargate_service_subnetids = var.private_subnets
  alb_arn                   = var.alb_arn
  log_group                 = aws_cloudwatch_log_group.cloudwatch-ecs-service.name
  existing_ecr              = var.existing_ecr

  desired_count      = var.ecs_capacity.min
  cpu_reservation    = var.ecs_capacity.cpu_reservation
  memory_reservation = var.ecs_capacity.memory_reservation

  enable_blue_green     = true
  deployment_controller = "CODE_DEPLOY"
  healthcheck_matcher   = var.healthcheck_matcher
  healthcheck_path      = var.healthcheck_path
  healthcheck_interval  = var.healthcheck_interval

  launch_type        = "FARGATE"
  task_role_arn      = aws_iam_role.ecs-service-task-role.arn
  execution_role_arn = var.execution_role_arn

  enable_execute_command = true
  ingress_rules          = var.ingress_rules
  environments           = var.environments
}

resource "aws_cloudwatch_log_group" "cloudwatch-ecs-service" {
  name = "ecs-${var.service_name}-${var.env}"
}

module "alb-rule-service" {
  source       = "git@github.com:in4it/terraform-modules.git//modules/alb-rule"
  listener_arn = var.alb_rule.listener_arn

  priority         = var.alb_rule.priority
  target_group_arn = module.service.target_group_arn
  condition_field  = var.alb_rule.condition_field
  condition_values = var.alb_rule.condition_values
}

module "codedeploy-service" {
  source             = "../ecs-codedeploy"
  name               = var.service_name
  ecs_cluster_name   = var.cluster_name
  ecs_service_name   = var.service_name
  execution_role_arn = var.execution_role_arn
  task_role_arn      = aws_iam_role.ecs-service-task-role.arn
  listener_arns      = [var.alb_rule.listener_arn]

  target_group_names = module.service.target_group_names
}
