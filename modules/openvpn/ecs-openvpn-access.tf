
module "openvpn-access" {
  source                    = "git@github.com:in4it/terraform-modules.git//modules/ecs-service"
  vpc_id                    = var.vpc_id
  cluster_arn               = aws_ecs_cluster.cluster.id
  execution_role_arn        = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn             = aws_iam_role.ecs-openvpn-access-task-role.arn
  aws_region                = data.aws_region.current.name
  healthcheck_matcher       = "200,301"
  healthcheck_path          = "/"
  cpu_reservation           = "256"
  memory_reservation        = "512"
  log_group                 = aws_cloudwatch_log_group.cloudwatch-ecs-openvpn-access.name
  desired_count             = 1
  alb_arn                   = var.alb_arn
  launch_type               = "FARGATE"
  platform_version          = "1.4.0"
  fargate_service_subnetids = var.private_subnets
  deployment_controller     = "ECS"
  enable_blue_green         = false

  application_name       = "openvpn-access"
  exposed_container_name = "openvpn-access"
  exposed_container_port = 8080

  containers = [
    {
      ecr_url             = var.openvpn_access_public_ecr
      application_name    = "openvpn-access"
      application_port    = "8080"
      host_port           = null
      additional_ports    = []
      application_version = "latest"
      cpu_reservation     = "256"
      memory_reservation  = "512"
      links               = []
      dependsOn           = []
      mountpoints         = []
      command             = []
      environments = [
        {
          name  = "STORAGE_TYPE"
          value = "S3"
        },
        {
          name  = "S3_BUCKET"
          value = aws_s3_bucket.configuration-bucket.id
        },
        {
          name  = "S3_PREFIX"
          value = "openvpn"
        },
        {
          name  = "AWS_REGION"
          value = data.aws_region.current.name
        },
      ]
      secrets = [
        {
          name      = "OAUTH2_CLIENT_ID"
          valueFrom = var.ouath2_client_id_parameter_arn
        },
        {
          name      = "CSRF_KEY"
          valueFrom = var.csrf_key_parameter_arn
        }
        , {
          name      = "CLIENT_CERT_ORG"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-${var.env}/vpn/CLIENT_CERT_ORG"
        },
        {
          name      = "OAUTH2_CLIENT_SECRET"
          valueFrom = var.ouath2_client_secret_parameter_arn
        },
        {
          name      = "OAUTH2_REDIRECT_URL"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-${var.env}/vpn/OAUTH2_REDIRECT_URL"
        },
        {
          name      = "OAUTH2_SCOPES"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-${var.env}/vpn/OAUTH2_SCOPES"
        },
        {
          name      = "OAUTH2_URL"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}-${var.env}/vpn/OAUTH2_URL"
        }
      ]
      environment_files = []
    }
  ]


  ingress_rules = [
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [var.alb_security_group_id]
    }
  ]
}

resource "aws_cloudwatch_log_group" "cloudwatch-ecs-openvpn-access" {
  name              = "ecs-${var.project_name}-openvpn-access-${var.env}"
  retention_in_days = var.log_retention_days
}
