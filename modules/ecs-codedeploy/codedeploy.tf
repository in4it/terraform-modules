resource "aws_codedeploy_app" "codedeploy" {
  compute_platform = "ECS"
  name             = var.name
}

resource "aws_codedeploy_deployment_group" "codedeploy" {
  app_name               = aws_codedeploy_app.codedeploy.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = var.name
  service_role_arn       = aws_iam_role.codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = var.deployment_option
    deployment_type   = var.deployment_type
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.listener_arns
      }

      dynamic target_group {
        for_each = var.target_group_names
        content {
          name = target_group.value
        }
      }
    }
  }
}
