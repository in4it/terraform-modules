data "aws_ami" "al" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.al.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name

  root_block_device {
    encrypted = var.root_block_device_encryption
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = var.name
  }

  user_data = <<EOF
  #!/bin/bash
  yum upgrade
  sudo systemctl status amazon-ssm-agent
  EOF
}

