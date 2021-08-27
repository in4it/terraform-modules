resource "aws_autoscaling_group" "vpn-asg" {
  depends_on = [aws_s3_bucket_object.oneloginconf]

  name                      = "${var.project_name}-vpn-asg-${var.env}"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.public_subnets


  launch_template {
    id      = aws_launch_template.vpn-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-vpn-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "vpn-launch-template" {
  name_prefix   = "${var.project_name}-vpn-lt-${var.env}"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.vpn-instance.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.vpn_iam_instance_profile.arn
  }

  user_data = base64encode(data.template_file.userdata.rendered)
}

data "template_file" "userdata" {
  template = file("./tpl/vpn-userdata.tpl")
  vars = {
    log_group    = aws_cloudwatch_log_group.cloudwatch-ec2-openvpn.name
    aws_region   = var.aws_region
    env          = var.env
    account      = var.aws_account_id
    domain       = "vpn.${var.domain}"
    hostedzoneid = var.hosted_zone_id
    project_name = var.project_name
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch-ec2-openvpn" {
  name = "ec2-${var.project_name}-openvpn-${var.env}"
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
  name   = "${var.project_name}-vpn-sg-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 1194
    protocol    = "udp"
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}