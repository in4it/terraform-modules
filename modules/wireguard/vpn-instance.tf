data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_instance" "vpn" {
  depends_on = [
    aws_s3_object.docker-compose,
    module.vpn-rds,
    aws_ssm_parameter.vpn-endpoint
  ]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.instance_subnet_id
  vpc_security_group_ids = [aws_security_group.vpn-instance.id]
  iam_instance_profile   = aws_iam_instance_profile.vpn_iam_instance_profile.name

  user_data_base64 = base64encode(templatefile("${path.module}/templates/userdata.sh", {
    aws_region         = data.aws_region.current.name
    aws_env_path       = "/vpn-${var.env}/"
    efs_fs_id          = aws_efs_file_system.vpn.id
    s3_bucket          = aws_s3_bucket.configuration-bucket.id
  }))

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  tags = merge({ Name = "vpn-${var.env}", Env = var.env }, var.tags)
}

resource "aws_eip" "vpn_ip" {
  instance = aws_instance.vpn.id
  vpc      = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch-ec2-vpn" {
  name              = "ec2-vpn-${var.env}"
  retention_in_days = var.log_retention_days
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "vpn-instance" {
  name   = "vpn-sg-${var.env}"
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
