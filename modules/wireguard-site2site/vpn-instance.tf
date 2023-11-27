data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_instance" "vpn" {
  depends_on = [
    aws_ssm_parameter.vpn-destination-pubkey,
  ]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.instance_subnet_id
  vpc_security_group_ids = [aws_security_group.vpn-instance.id]
  iam_instance_profile   = aws_iam_instance_profile.vpn_iam_instance_profile.name
  source_dest_check      = var.source_dest_check

  user_data_base64     = base64encode(templatefile("${path.module}/templates/userdata.sh", {
    aws_region         = data.aws_region.current.name
    aws_env_path       = "/${var.identifier}-vpn-${var.env}/"
    kms_id             = aws_kms_key.vpn-ssm-key.id

    vpn_destination_pubkey    = var.vpn_destination_pubkey
    vpn_destination_public_ip = var.vpn_destination_public_ip
  }))

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  tags = merge({ Name = "${var.identifier}-vpn-${var.env}", Env = var.env }, var.tags)
}

resource "aws_eip" "vpn_ip" {
  instance = aws_instance.vpn.id
  vpc      = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch-ec2-vpn" {
  name              = "${var.identifier}-ec2-vpn-${var.env}"
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
  name   = "${var.identifier}-vpn-sg-${var.env}"
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
