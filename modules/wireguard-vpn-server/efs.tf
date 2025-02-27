resource "aws_efs_file_system" "vpn-server-config" {
  performance_mode = "generalPurpose"
  encrypted        = var.efs_encrypted
  kms_key_id       = var.efs_kms_key_id
  
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

## EFS Backups
resource "aws_efs_backup_policy" "vpn-efs" {
  count = var.efs_backup_enabled ? 1 : 0
  file_system_id = aws_efs_file_system.vpn-server-config.id

  backup_policy {
    status = "ENABLED"
  }
}

