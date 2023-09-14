module "autoscaling" {
  source = "github.com/in4it/terraform-modules//modules/fargate-autoscale?ref=4116f4e630c0fe5e3859ebbee457a427220c1737"

  service_name   = var.service_name
  cluster_name   = var.cluster_name
  aws_account_id = var.aws_account_id
  env            = var.env

  min_capacity = var.ecs_capacity.min
  max_capacity = var.ecs_capacity.max
}

