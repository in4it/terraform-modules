resource "aws_efs_file_system" "vpn" {
  performance_mode = "generalPurpose"

  tags = {
    Name = "vpn"
  }
}

resource "aws_efs_mount_target" "vpn" {
  count = 2

  file_system_id  = aws_efs_file_system.vpn.id
  subnet_id       = var.efs_subnet_ids[count.index]
  security_groups = [aws_security_group.vpn-efs.id]
}

resource "aws_security_group" "vpn-efs" {
  name        = "vpn-efs"
  description = "vpn-efs"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    protocol        = "tcp"
    to_port         = 2049
    security_groups = [aws_security_group.vpn-instance.id]
    description     = "Allow traffic from vpn to efs"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-efs"
  }
}