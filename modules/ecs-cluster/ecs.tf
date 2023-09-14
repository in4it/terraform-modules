#
# ECS ami
#

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # AWS
}

#
# ECS cluster
#

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

#
# launchconfig
#
resource "aws_launch_configuration" "cluster" {
  name_prefix          = "ecs-${var.cluster_name}-launchconfig"
  image_id             = data.aws_ami.ecs.id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.cluster-ec2-role.id
  security_groups      = [aws_security_group.cluster.id]
  user_data            = templatefile("${path.module}/templates/ecs_init.tpl", {
    cluster_name = var.cluster_name
  })
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

#
# autoscaling
#
resource "aws_autoscaling_group" "cluster" {
  name                 = "ecs-${var.cluster_name}-autoscaling"
  vpc_zone_identifier  = split(",", var.vpc_subnets)
  launch_configuration = aws_launch_configuration.cluster.name
  termination_policies = split(",", var.ecs_termination_policies)
  min_size             = var.ecs_minsize
  max_size             = var.ecs_maxsize
  desired_capacity     = var.ecs_desired_capacity

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-ecs"
    propagate_at_launch = true
  }
}

