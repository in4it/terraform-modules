data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_instance" "openvpn" {
  depends_on = [
    aws_s3_bucket_object.oneloginconf,
    aws_s3_bucket_object.openvpn-client,
    aws_s3_bucket_object.openvpn-vars,
  ]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.vpn-instance.id]
  iam_instance_profile   = aws_iam_instance_profile.vpn_iam_instance_profile.name

  user_data_base64 = base64encode(templatefile("${path.module}/tpl/vpn-userdata.tpl", {
    log_group          = aws_cloudwatch_log_group.cloudwatch-ec2-openvpn.name
    aws_region         = data.aws_region.current.name
    env                = var.env
    account            = data.aws_caller_identity.current.account_id
    domain             = var.vpn_domain
    project_name       = var.project_name
    openvpn_public_ecr = var.openvpn_public_ecr
    listeners          = var.listeners
  }))

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.project_name}-vpn-${var.env}"
    Env  = var.env
  }
}

resource "aws_eip" "vpn_ip" {
  instance = aws_instance.openvpn.id
  vpc      = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch-ec2-openvpn" {
  name              = "ec2-${var.project_name}-openvpn-${var.env}"
  retention_in_days = var.log_retention_days
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
}

resource "aws_security_group" "vpn-instance" {
  name   = "${var.project_name}-openvpn-sg-${var.env}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.listeners
    content {
      from_port   = ingress.value.port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.port
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}