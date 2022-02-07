resource "aws_security_group" "lb" {
  name        = var.lb_name
  vpc_id      = var.vpc_id
  description = var.lb_name


  dynamic "ingress" {
    for_each = var.tcp_ingress
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "cluster-allow-lb" {
  count                    = length(var.ecs_sg)
  security_group_id        = element(var.ecs_sg, count.index)
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

