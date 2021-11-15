resource "aws_iam_instance_profile" "vpn_iam_instance_profile" {
  name = "${var.project_name}-vpn-iam-instance-profile-${var.env}"
  role = aws_iam_role.vpn-iam-role.name
}

resource "aws_iam_role" "vpn-iam-role" {
  name = "${var.project_name}-vpn-iam-role-${var.env}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "vpn-iam-policy-attachment" {
  name       = "${var.project_name}-vpn-iam-policy-attachment-${var.env}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  roles      = [aws_iam_role.vpn-iam-role.id]
}

resource "aws_iam_role_policy" "vpn-custom-policy" {
  policy = data.aws_iam_policy_document.vpn-custom-policy.json
  role   = aws_iam_role.vpn-iam-role.id
}
data "aws_iam_policy_document" "vpn-custom-policy" {
  statement {
    resources = ["*"]
    effect    = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
  }
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetHostedZone"
    ]
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/${var.hosted_zone_id}"]
  }
}
