data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_instance" "vpn-server" {
  depends_on = [
    aws_efs_mount_target.vpn-server-config
  ]
  ami                    = data.aws_ami.vpn-server.id
  instance_type          = var.instance_type
  subnet_id              = var.instance_subnet_id
  vpc_security_group_ids = [aws_security_group.vpn-server.id]
  iam_instance_profile   = var.instance_profile_name != "" ? var.instance_profile_name : aws_iam_instance_profile.vpn-server.name

  user_data_base64 = base64encode(templatefile("${path.module}/templates/userdata.sh", {
    aws_region         = data.aws_region.current.name
    efs_fs_id          = aws_efs_file_system.vpn-server-config.id
  }))

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    instance_metadata_tags      = "enabled"
  }

  tags = merge({ Name = "vpn-server-${var.env}", env = var.env, license = var.license }, var.tags)
}

resource "aws_eip" "vpn-server" {
  instance = aws_instance.vpn-server.id

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_ami" "vpn-server" {
  owners      = [var.ami_owner]
  most_recent = true

  filter {
    name   = "name"
    values = ["in4it-vpn-server*"]
  }
}

resource "aws_security_group" "vpn-server" {
  name   = "vpn-server-${var.env}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.listeners
    content {
      from_port   = ingress.value.port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
