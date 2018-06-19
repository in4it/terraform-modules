resource "aws_security_group" "alb" {
  name        = "${var.ALB_NAME}"
  vpc_id      = "${var.VPC_ID}"
  description = "${var.ALB_NAME}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# workaround for https://github.com/hashicorp/terraform/issues/12570
locals {
  ecs_sg_count = "${ var.ECS_SG == "" ? 0 : 1 }"
}

resource "aws_security_group_rule" "cluster-allow-alb" {
  count                    = "${local.ecs_sg_count}"
  security_group_id        = "${var.ECS_SG}"
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.alb.id}"
}
