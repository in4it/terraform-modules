resource "aws_efs_file_system" "vpn-server-config" {
  performance_mode = "generalPurpose"

  tags = {
    Name = "vpn-server-config"
  }
}

resource "aws_efs_mount_target" "vpn-server-config" {
  count = length(var.efs_subnet_ids)

  file_system_id  = aws_efs_file_system.vpn-server-config.id
  subnet_id       = var.efs_subnet_ids[count.index]
  security_groups = [aws_security_group.vpn-efs.id]
}

resource "aws_security_group" "vpn-efs" {
  name        = "vpn-server-config-efs"
  description = "vpn-server-config-efs"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    protocol        = "tcp"
    to_port         = 2049
    security_groups = [aws_security_group.vpn-server.id]
    description     = "Allow traffic from vpn-server to efs"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-server-config-efs"
  }
}