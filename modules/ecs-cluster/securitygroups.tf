resource "aws_security_group" "cluster" {
  name        = var.CLUSTER_NAME
  vpc_id      = var.VPC_ID
  description = var.CLUSTER_NAME
}

resource "aws_security_group_rule" "cluster-allow-ssh" {
  count                    = var.ENABLE_SSH ? 1 : 0
  security_group_id        = aws_security_group.cluster.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = var.SSH_SG
}

resource "aws_security_group_rule" "cluster-egress" {
  security_group_id = aws_security_group.cluster.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

