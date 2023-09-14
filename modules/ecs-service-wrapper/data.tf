data "aws_ecs_cluster" "this" {
  cluster_name = var.cluster_name
}
