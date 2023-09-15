module "ecs-wrapper-example" {
  source = "github.com/in4it/terraform-modules//modules/ecs-service-wrapper?ref=dfa7c8b13515898f7899e936577291776ee8282a"

  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  env            = var.env

  service_name       = "example-servicename-${var.env}"
  cluster_name       = "example-${var.env}"
  execution_role_arn = module.ecs-cluster.execution_role_arn

  vpc_id               = data.terraform_remote_state.network.outputs.vpc_id
  private_subnets      = slice(data.terraform_remote_state.network.outputs.private_subnets, 0, 2)
  private_subnets_cidr = var.vpc_private_subnets[0]

  # Task Configs
  application_port     = "80"
  healthcheck_matcher  = "200"
  healthcheck_path     = "/"
  healthcheck_interval = 30
  ecs_capacity = {
    min                = var.ecs_services.portal.min
    max                = var.ecs_services.portal.max
    cpu_reservation    = var.ecs_services.portal.cpu
    memory_reservation = var.ecs_services.portal.mem
  }

  # ALB
  alb_arn = module.loadbalancer.lb_arn
  alb_rule = {
    listener_arn     = module.loadbalancer.https_listener_arn
    priority         = 97
    condition_field  = "host-header"
    condition_values = ["www.${var.domain}", var.domain]
  }

  # Security Group
  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.loadbalancer.security-group-id]
    }
  ]
  task_role_policy_json = aws_iam_role_policy.portal.policy
}
