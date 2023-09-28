resource "aws_efs_file_system" "this" {
  creation_token   = var.name
  encrypted        = var.encrypted
  performance_mode = var.performance_mode

  dynamic "lifecycle_policy" {
    for_each = [for k, v in var.lifecycle_policies : { (k) = v }]

    content {
      transition_to_primary_storage_class = try(lifecycle_policies.value.transition_to_primary_storage_class, null)
      transition_to_ia                    = try(lifecycle_policies.value.transition_to_ia, null)
    }
  }
  tags = {
    Name = "${var.name}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.this.id]
}

resource "aws_security_group" "this" {
  name        = "${var.name}-efs-sg"
  description = "${var.name}-efs-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    protocol        = "tcp"
    to_port         = 2049
    security_groups = var.ingress_security_groups
    description     = "Allow traffic to EFS"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-efs-sg"
  }
}
